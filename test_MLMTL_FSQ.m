% X,Y: cell of 1 x numTasks
% X{i} =  featureDim  x numSample
% Y{i} =  1 x numSamples
% indicator: mode dim of tensor [ featureDim x TaskCategory1 x TaskCategory2 ...]
% beta: hyper_para, lambda: weight of regularizaer
% outerNiTPre: iteration number 100 is enough
clear all;
addpath(genpath('.'));
% load 'climateP17'
% Climate dataset has  125 locations in 17 agents, 156 days of training
% data. Task: predict the values for certain location and certain agents


% load 'genomeP'
% Genomic dataset has 798 location(??) for 10 speciest, in 6 time stamp


load 'tensor_checkin_small'

global verbose;
verbose = 1;
nType = length(series);
[nLoc, nTime] = size(series{1});

numTask = nLoc * nType;



X = cell(1,numTask);
Y = cell(1,numTask);

% nLag = 5;
% nSample = nTime-nLag;
% for type = 1:nType
%     % contruct feature and label for each task
%     for loc = 1:nLoc
%          task_idx = (type-1)*nLoc+loc;
%          features = zeros(nLag, nSample);
%          labels = zeros(nSample,1);
%          
%          for sample = 1:nSample
%              start_idx = sample;
%              end_idx = sample+nLag-1;
%              features(:,sample) = series{type}(loc,start_idx:end_idx)';
%              labels(sample) = series{type}(loc,end_idx+1);
%          end
%          
%          X{task_idx}= features;
%          Y{task_idx}= labels;
%     end
% end
% indicators = [nLag, nType, nLoc];


nSample = nTime-1;
 for type = 1:nType
     % construct feature and label for each task
     for loc = 1:nLoc
         task_idx = (type-1)*nLoc + loc;
         features = zeros(nLoc,nSample);
         labels = zeros(nSample,1);
         
         for sample = 1:nSample
             features(:,sample) = series{type}(:,sample);
             labels(sample) = series{type}(loc,sample+1);
         end
         
         X{task_idx} = features;
         Y{task_idx} = labels;
     end
 end
 dimModes = [nLoc, nLoc,nType];        

fprintf('Data Constructed\n');

%%
beta = 1e-2;
outerNiTPre = 200;
% r_Convex = [];
% r_Mixture = [];

pr = 0.1;
[TrainIdx, TestIdx]  = crossvalind('HoldOut',nSample,pr);
X_train = cell(1,numTask);
Y_train = cell(1,numTask);
X_test = X_train;
Y_test = Y_train;



for i = 1:numTask
    X_train{i} = X{i}(:,TrainIdx);
    Y_train{i} = Y{i}(TrainIdx);
    X_test{i} = X{i}(:,TestIdx);
    Y_test{i} = Y{i}(TestIdx);
end

if verbose
    fprintf('Data Splitted: Training %d , Testing %d\n', 1-pr, pr);
end


%% train-test (with cross validation)

lambdas = logspace(-3,3,10);
% lambda = 3.162278e+02;

paras.beta = beta;
paras.dimModes = dimModes;
paras.outIter = outerNiTPre;

% W_Convex = MLMTL_Crosval(X_train,Y_train,@MLMTL_Convex,@MLMTL_Test,lambdas, paras);
% W_Mixture = MLMTL_Crosval(X_train,Y_train,@MLMTL_Mixture,@MLMTL_Test,lambdas, paras);


% select best parameter
fprintf('Running Overlapped \n');
[ W_Convex,~, ~, train_time ] = MLMTL_Convex( X_train, Y_train, dimModes, beta, 2.15, outerNiTPre);
Quality = MLMTL_Test(X_test,Y_test, W_Convex);
if verbose
    fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
end
%%

fprintf('Running Mixture \n');
[ W_Mixture ,~ ,~,train_time] = MLMTL_Mixture( X_train, Y_train, dimModes, beta, 10,outerNiTPre);
Quality = MLMTL_Test(X_test,Y_test, W_Mixture);

if verbose
    fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
end

% r_Convex = [r_Convex,MSE_Convex];
% r_Mixture = [r_Mixture, MSE_Mixture];


%%

% plot( 0.1:0.1:0.9,r_Convex(1:end),'b'); hold on;
% plot( 0.1:0.1:0.9,r_Mixture(1:end),'r'); 
% ylim([0,1]); hold off;
% legend('Romera-ParedesICML13','Latent approach');
% save ('MSE_TrainSize.mat');
% exit;






% X,Y: cell of 1 x numTasks
% X{i} =  featureDim  x numSample
% Y{i} =  1 x numSamples
% indicator: mode dim of tensor [ featureDim x TaskCategory1 x TaskCategory2 ...]
% beta: hyper_para, lambda: weight of regularizaer
% outerNiTPre: iteration number 100 is enough
clear all;
load 'climateP17'
% Climate dataset has  125 locations in 17 agents, 156 days of training
% data. Task: predict the values for certain location and certain agents


%load 'genomeP'
% Genomic dataset has 798 location(??) for 10 speciest, in 6 time stamp
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
lambdas = logspace(-2,2,5);
r_Convex = [];
r_Mixture = [];
for pr = fliplr(0.1:0.1:0.9)
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

% lambdas = logspace(-8,2,10);
lambda = 3.162278e+02;

% paras.beta = beta;
% paras.dimModes = dimModes;
% paras.outIter = outerNiTPre;

% W_Convex = MLMTL_Crosval(X_train,Y_train,@MLMTL_Convex,@MLMTL_Test,lambdas, paras);
% W_Mixture = MLMTL_Crosval(X_train,Y_train,@MLMTL_Mixture,@MLMTL_Test,lambdas, paras);

[ W_Convex ,~, ~ ] = MLMTL_Convex( X, Y, dimModes, beta, lambda, outerNiTPre);

[ W_Mixture ,~ ,~] = MLMTL_Mixture( X, Y, dimModes, beta, lambda,outerNiTPre);

% select best parameter

MSE_Convex = MLMTL_Test(X_test,Y_test, W_Convex);
MSE_Mixture = MLMTL_Test(X_test,Y_test, W_Mixture);

if verbose
    fprintf('Prediction MSE Convex: %d Mixture:  %d\n ',MSE_Convex,MSE_Mixture);
end

r_Convex = [r_Convex,MSE_Convex];
r_Mixture = [r_Mixture, MSE_Mixture];
end

%%
% plot(lambda(1:4),r_Convex,'b');hold on;
% plot(lambda(1:4),r_Mixture,'r'); hold off;
% legend('Romera-ParedesICML13','Latent approach');
save ('MSE_TrainSize.mat');
exit;


%%
% 
% W_tensor = reshape(W, indicators);
% [p1,p2,p3] = tensorModeRank(W_tensor);ss
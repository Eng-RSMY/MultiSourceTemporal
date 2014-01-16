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
[TrainIdx, TestIdx]  = crossvalind('HoldOut',nSample,0.4);
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
fprintf('Eval/Test Splitted\n');


%% train (with cross validation)
beta = 1e-2;
lambda = 1e-3;
outerNiTPre = 100;
% lambdas = logspace(-8,2,10);
lambdas = 316:200:800;

paras.beta = beta;
paras.dimModes = dimModes;
paras.outIter = outerNiTPre;

W_Convex = MLMTL_Crosval(X_train,Y_train,@MLMTL_Convex,@MLMTL_Test,lambdas, paras);
W_Mixture = MLMTL_Crosval(X_train,Y_train,@MLMTL_Mixture,@MLMTL_Test,lambdas, paras);



% select best parameter

%%
MSE_Convex = MLMTL_Test(X_test,Y_test, W_Convex);
MSE_Mixture = MLMTL_Test(X_test,Y_test, W_Mixture);


fprintf('Prediction MSE Convex: %d Mixture:  %d\n ',MSE_Convex,MSE_Mixture);
save ('MSE_CroVal.mat');

%save('result.mat','r_Convex','r_Mixture');
%%
% plot(lambda(1:4),r_Convex,'b');hold on;
% plot(lambda(1:4),r_Mixture,'r'); hold off;
% legend('Romera-ParedesICML13','Latent approach');

exit

%%
% 
% W_tensor = reshape(W, indicators);
% [p1,p2,p3] = tensorModeRank(W_tensor);ss
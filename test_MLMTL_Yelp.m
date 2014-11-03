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

% load 'tensor_checkin_small'
load 'yelp.mat'

global verbose;
verbose = 1;
alpha = 0.1;
beta = 1e-2;
ratio = 0.1;
outerNiTPre = 100;

nType = length(series);
[nLoc, ~] = size(series{1});

ratio = 0.1;
% lambdas = logspace(-3,3,10);

dimModes = [nLoc, nLoc,nType]; 

[Dat_eval , Dat_test] = MLMTL_Datpre(series,ratio); 

%% train-test (with cross validation)

lambdas = logspace(-3,3,10);
lambda = 3.162278e+02;

paras.beta = beta;
paras.dimModes = dimModes;
paras.outIter = outerNiTPre;

W_Convex = MLMTL_Crosval(X_train,Y_train,@MLMTL_Convex,@MLMTL_Test,lambdas, paras);
W_Mixture = MLMTL_Crosval(X_train,Y_train,@MLMTL_Mixture,@MLMTL_Test,lambdas, paras);


use  select best parameter
fprintf('Running Overlapped \n');
[ W,~, ~, train_time ] = MLMTL_Convex( Dat_eval.X, Dat_eval.Y, dimModes, beta, 2.15, outerNiTPre);
Quality = MLMTL_Test(Dat_test.X, Dat_test.Y, W);
if verbose
    fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
end

save('MLMTL_Convex_yelp.mat','Quality','train_time','W');

%%

fprintf('Running Mixture \n');
[ W ,~ ,~,train_time] = MLMTL_Mixture( Dat_eval.X, Dat_eval.Y, dimModes, beta, 10,outerNiTPre);
Quality = MLMTL_Test(Dat_test.X, Dat_test.Y, W);

if verbose
    fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
end

save('MLMTL_Mixture_yep.mat','Quality','train_time','W');


fprintf('Running Tucker \n');
[W,W_tensor] = MLMTL_Tucker (Dat_eval.X, Dat_eval.Y, dimModes,alpha);
Quality = MLMTL_Test(Dat_test.X, Dat_test.Y, W);
disp(Quality.RMSE);
save('./result/climate/MLMTL_Tucker_yelp.mat','Quality','W');


exit;






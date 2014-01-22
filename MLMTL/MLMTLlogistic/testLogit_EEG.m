clear;
clc;
addpath(genpath('~/Documents/MATLAB/MultiSourceTemporal'))
global verbose;
verbose =1;

load 'eeg_small';
[nChannel, nTime, nTrial] = size(series);

nSample = nTrial;
nTasks = nChannel;
X = cell (1, nTasks);
Y = cell (1, nTasks);

for t = 1: nTasks
    X{t} = squeeze(series(t,:,:));
    Y{t} = label;
end
fprintf('Data Constructed\n');

pr = 0.2;

[TrainIdx, TestIdx]  = crossvalind('HoldOut',nSample,pr);
X_train = cell(1,nTasks);
Y_train = cell(1,nTasks);
X_test = X_train;
Y_test = Y_train;



for i = 1:nTasks
    X_train{i} = X{i}(:,TrainIdx);
    Y_train{i} = Y{i}(TrainIdx);
    X_test{i} = X{i}(:,TestIdx);
    Y_test{i} = Y{i}(TestIdx);
end
fprintf('Data Splitted: Training %d , Testing %d\n', 1-pr, pr);

dimModes = [nTime, 4,4];
beta = 1e-2;
% lambda = 1e-3;
paras.beta = beta;
paras.dimModes = dimModes;
lambdas = logspace(-3,3,8);

% [ W_Cvx ,tensorW ] = MLMTL_Cvx_Logit( X_train, Y_train, dimModes,beta, lambda );
% [ W_Mix ,tensorW ] = MLMTL_Mix_Logit( X_train, Y_train, dimModes,beta, lambda );

[ W_Cvx ] = MLMTL_Crosval( X_train,Y_train, @MLMTL_Cvx_Logit, @MLMTL_Test_Logit,lambdas, paras);
[ W_Mix ] = MLMTL_Crosval( X_train,Y_train, @MLMTL_Mix_Logit, @MLMTL_Test_Logit,lambdas, paras);

[ Err_Cvx ] = MLMTL_Test_Logit(X_test, Y_test, W_Cvx );
[ Err_Mix ] = MLMTL_Test_Logit(X_test, Y_test, W_Mix );
fprintf('Prec Cvx %d , Prec Mix %d\n', 1-Err_Cvx, 1-Err_Mix);



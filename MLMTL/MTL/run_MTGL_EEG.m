clear;clc;
addpath(genpath('~/Documents/MATLAB/MultiSourceTemporal'))

load 'eeg_small';
ratio = 0.1;
lambdas = logspace(-3,3,10);
[Dat_eval , Dat_test] = MTGL_Logit_Datpre(series,label, ratio); 

fprintf('Running Lasso\n');

[W,opt_lambda,train_time] = MTGL_Crosval(Dat_eval.X, Dat_eval.Y, 'LassoLogit',lambdas);
Quality = MTGL_Test(Dat_test.X, Dat_test.Y, W);
fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
save('MTGL_Lasso_EEG.mat','Quality','train_time','opt_lambda','W');

fprintf('Running L21\n');
[W,opt_lambda,train_time] = MTGL_Crosval(Dat_eval.X, Dat_eval.Y, 'L21Logit',lambdas);
Quality = MTGL_Test(Dat_test.X, Dat_test.Y, W);
fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
save('MTGL_L21_EEG.mat','Quality','train_time','opt_lambda','W');


exit;

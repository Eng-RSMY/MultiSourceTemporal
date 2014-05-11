addpath(genpath('.'));
load 'climateP3'

nType = length(series);
[nLoc, ~] = size(series{1});

ratio = 0.1;
% lambdas = logspace(-3,3,10);
lambdas = logspace(2,3,4);
beta = 1e-3;
dimModes = [nLoc, nLoc,nType];  
paras.beta = beta;
paras.dimModes = dimModes;



[Dat_eval , Dat_test] = MLMTL_Datpre(series,ratio); 

%%
% fprintf('Running Mixture\n');
% [W,opt_lambda,train_time] = MLMTL_Crosval(Dat_eval.X, Dat_eval.Y, @MLMTL_Mixture,@MLMTL_Test,lambdas, paras);
% Quality = MLMTL_Test(Dat_test.X, Dat_test.Y, W);
% fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
% save('MLMTL_Mixture_climateP4.mat','Quality','train_time','opt_lambda','W');
% 
% fprintf('Running Convex\n');
% [W,opt_lambda,train_time] = MLMTL_Crosval(Dat_eval.X, Dat_eval.Y, @MLMTL_Convex,@MLMTL_Test,lambdas, paras);
% Quality = MLMTL_Test(Dat_test.X, Dat_test.Y, W);
% fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);
% save('MLMTL_Convex_climateP3.mat','Quality','train_time','opt_lambda','W');

%%
fprintf('Running Tucker \n');
[W,W_tensor] = MLMTL_Tucker (Dat_eval.X, Dat_eval.Y, dimModes,0.5);
Quality = MLMTL_Test(Dat_test.X, Dat_test.Y, W);
disp(Quality.RMSE);
save('./result/climate/MLMTL_Tucker_climateP3.mat','Quality','W');

exit;



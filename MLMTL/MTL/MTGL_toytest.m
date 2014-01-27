clear;clc;
r = 3;
q = 4;
p = 20;
series = cell(1,r);
for i = 1:r
    series{i} = rand(q,p);
end
% [ W_tensor ] = MTGL( series,'L21', 1e-4);

ratio = 0.1;
lambdas = [-1,1,2];
[Dat_eval , Dat_test] = MTGL_Datpre(series,ratio); 

[W,opt_lambda,train_time] = MTGL_Crosval(Dat_eval.X, Dat_eval.Y, 'LassoLogit',lambdas);
Quality = MTGL_Test(Dat_test.X, Dat_test.Y, W);
fprintf('RMSE %d, NRMSE %d, Rank %d, Time %d\n', Quality.RMSE, Quality.NRMSE,Quality.Rank, train_time);

% save('quality.mat','Quality');


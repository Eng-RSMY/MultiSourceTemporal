clc;
clear;
addpath(genpath('../../MultiSourceTemporal'));
tLen = [10, 50, 100, 200];

Qualities = cell(4,10);
Ws = cell(4,10);

for t = 1:length(tLen)
    fprintf('\n Training size %d ', tLen(t));
    for iter = 1:10
        fprintf('Iter  %d ', iter);
        name = sprintf('synth%d_%d.mat', tLen(t), iter);
        data = load(['./data/synth/datasets/' name]);
        tr_series = data.tr_series;
        te_series = data.te_series;
        A = data.A;

        r = length(tr_series);
        p = size(tr_series{1},1);
        dimModes = [p, p, r];
        beta = 1e-2;
        lambda = 5;


        [Dat_train, ~] = MLMTL_Datpre (tr_series, 0);
        [Dat_test, ~] = MLMTL_Datpre(te_series,0);
        tic 
        [W] = MLMTL_Convex( Dat_train.X, Dat_train.Y, dimModes, beta, lambda);
        train_time = toc;
    %     Quality = testQuality2(W_tensor, A, Dat_test.Y, Dat_test.X);
        W0 = reshape(A, [p,p*r]);
        Quality = MLMTL_Test(Dat_test.X, Dat_test.Y, W,  W0);
        fprintf('RMSE %d, RMSE_est\n', Quality.RMSE,  Quality.RMSE_est);

        Qualities{t,iter} = Quality;
        Ws{t,iter} = W;
    end
end
% 
% [ W_r_mixture tensorW_r_mixture Ls_Mixture] = MLMTL_Mixture( X, Y, [nDim,folds], beta, lambda);
% toc;

%%
RMSEs =[];
for t = 1:4
    RMSEs = [RMSEs ,Qualities{t}.RMSE];
end


%%



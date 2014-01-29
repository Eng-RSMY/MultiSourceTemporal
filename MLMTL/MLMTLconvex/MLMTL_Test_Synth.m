clc;
clear;
addpath(genpath('~/Documents/MATLAB/MultiSourceTemporal'));
tLen = [10, 50, 100, 200];

Qualities = cell(4,10);
Ws = cell(4,10);

lambdas = logspace(-3,3,10);

 fprintf('Running Convex \n');
for t = 1:length(tLen)
    fprintf('\n Training size %d ', tLen(t));
    opt_lambda = 0;    
    for iter = 1:10
        fprintf('Iter  %d ', iter);
        name = sprintf('synth%d_%d.mat', tLen(t), iter);
        data = load([name]);
        tr_series = data.tr_series;
        te_series = data.te_series;
        v_series = data.v_series;
        A = data.A;

        r = length(tr_series);
        p = size(tr_series{1},1);
        dimModes = [p, p, r];
        
        W0 = reshape(A, [p,p*r]);
        beta = 1e-2;
        lambda = 1e-2;
        

        [Dat_train, ~] = MLMTL_Datpre (tr_series, 0);
        [Dat_test, ~] = MLMTL_Datpre(te_series,0);
        [Dat_valid,~] =  MLMTL_Datpre(v_series,0);
        
        if(iter ==1)
            RMSE_est = [];

            for lambda= lambdas
                [W] = MLMTL_Convex( Dat_train.X, Dat_train.Y, dimModes, beta, lambda);
                Quality_valid = MLMTL_Test(Dat_valid.X, Dat_valid.Y, W ,W0);
                RMSE_est = [RMSE_est, Quality_valid.RMSE_est];
            end
            [~,idx] = min(RMSE_est);
            opt_lambda = lambdas(idx);
            fprintf('opt_lambda %d\n',opt_lambda);
        end
        tic 
        [W] = MLMTL_Convex( Dat_train.X, Dat_train.Y, dimModes, beta, opt_lambda);
    %     Quality = testQuality2(W_tensor, A, Dat_test.Y, Dat_test.X);
        train_time = toc;
        Quality = MLMTL_Test(Dat_test.X, Dat_test.Y, W,  W0);
        Quality.Time = train_time;
        fprintf('RMSE %d, RMSE_est %d \n', Quality.RMSE,  Quality.RMSE_est);

        Qualities{t,iter} = Quality;
        Ws{t,iter} = W;
    end
end

save('Synth_MLMTL_Convex.mat','Qualities','Ws');

%%

 fprintf('Running Mixture \n');

for t = 1:length(tLen)
    fprintf('\n Training size %d ', tLen(t));
    for iter = 1:10
        fprintf('Iter  %d ', iter);
        name = sprintf('synth%d_%d.mat', tLen(t), iter);
        data = load([name]);
        tr_series = data.tr_series;
        te_series = data.te_series;
        v_series = data.v_series;

        A = data.A;

        r = length(tr_series);
        p = size(tr_series{1},1);
        dimModes = [p, p, r];
        W0 = reshape(A, [p,p*r]);

        beta = 1e-2;
        lambda = 1e-2;


        [Dat_train, ~] = MLMTL_Datpre (tr_series, 0);
        [Dat_test, ~] = MLMTL_Datpre(te_series,0);
        [Dat_valid,~] =  MLMTL_Datpre(v_series,0);

        opt_lambda = 0;
        RMSE_est = [];
         
        for lambda= lambdas
            [W] = MLMTL_Mixture( Dat_train.X, Dat_train.Y, dimModes, beta, lambda);
            Quality_valid = MLMTL_Test(Dat_valid.X, Dat_valid.Y, W ,W0);
            RMSE_est = [RMSE_est, Quality_valid.RMSE_est];
        end
        [~,idx] = min(RMSE_est);
        opt_lambda = lambdas(idx);
        
        tic 
        [W] = MLMTL_Mixture( Dat_train.X, Dat_train.Y, dimModes, beta, lambda);
        train_time = toc;
    %     Quality = testQuality2(W_tensor, A, Dat_test.Y, Dat_test.X);
        Quality = MLMTL_Test(Dat_test.X, Dat_test.Y, W,  W0);
        Quality.Time = train_time;
        fprintf('RMSE %d, RMSE_est %d, Selected Lambda %d \n', Quality.RMSE,  Quality.RMSE_est,opt_lambda);

        Qualities{t,iter} = Quality;
        Ws{t,iter} = W;
    end
end

save('Synth_MLMTL_Mixture.mat','Qualities','Ws');
exit;

%%



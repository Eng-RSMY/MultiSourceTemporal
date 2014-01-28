function MTGL_Interface_Synth( funcname )
%MTGL_INTERFACE_SYNTH Summary of this function goes here
%   Detailed explanation goes here

tLen = [10, 50, 100, 200];

Qualities = cell(4,10);
Ws = cell(4,10);
lambdas = logspace(-3,3,10);

for t = 1:length(tLen)
    fprintf('Training size %d\n ', tLen(t));
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
        W0 = reshape(A, [p,p*r]);
      

        [Dat_train, ~] = MTGL_Datpre (tr_series, 0);
        [Dat_test, ~]  = MTGL_Datpre(te_series,0);
        [Dat_valid,~]  = MTGL_Datpre(v_series,0);
        
        opt_lambda = 0;
        
        RMSE = inf;
        for lambda= lambdas
            tic 
            [W] = MTGL_Train( Dat_train.X, Dat_train.Y, funcname, lambda);
            train_time = toc;
            Quality_valid = MTGL_Test(Dat_valid.X, Dat_valid.Y, W ,W0);
            if(Quality_valid.RMSE<RMSE)
                opt_lambda = lambda;
                opt_W = W;
                RMSE = Quality_valid.RMSE;
            end
        end

    %     Quality = testQuality2(W_tensor, A, Dat_test.Y, Dat_test.X);
  
        Quality = MTGL_Test(Dat_test.X, Dat_test.Y, opt_W ,W0);
        Quality.Time = train_time;
        fprintf('RMSE %d\n', Quality.RMSE);

        Qualities{t,iter} = Quality;
        Ws{t,iter} = opt_W;
    end
end

save( strcat('./MLMTL/MTL/MGTL_',funcname,'_Synth.mat'),'Qualities','Ws','opt_lambda');

end


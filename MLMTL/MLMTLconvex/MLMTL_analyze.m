load ('Synth_MLMTL_Convex');
[T,N] = size(Qualities);
RMSE_est = zeros(T,N);
for t = 1:T
    for i = 1:N
        RMSE_est(t,i) =  Qualities{t,i}.RMSE_est;
    end
end
RMSE_est = RMSE_est';
mean_Cvx = mean(RMSE_est);
var_Cvx = std(RMSE_est);
tLen = [10, 50, 100, 200];


load ('Synth_MLMTL_Mixture');
RMSE_est = zeros(T,N);
for t = 1:T
    for i = 1:N
        RMSE_est(t,i) =  Qualities{t,i}.RMSE_est;
    end
end
RMSE_est = RMSE_est';
mean_Mix = mean(RMSE_est);
var_Mix = std(RMSE_est);
tLen = [10, 50, 100, 200];
errorbar(tLen, [mean_Cvx ], [var_Cvx],'b'); hold on;
errorbar(tLen, mean_Mix, var_Mix,'r'); hold on;


    
clear; clc;
genData_ClimateP3;

lambda = 1e-5;
beta = 2;
sigma = 1e-1;
Dims = [nObserve, nObserve, nTasks];
cov_emp = zeros(Dims);
time = 1;

for t = 1: nTasks
    X_t = series{t}(observe_idx,:)';
    cov_emp(:,:,t) = cov(X_t);
end

[ W,fs ] = cov_kriging( cov_emp, beta, lambda, Dims );

%%
sigma = 1e-1;
Dims = [nObserve, nMissing, nTasks];

cov_est = zeros(Dims);

for t = 1: nTasks
    cov_est(:,:,t) = nwreg(W(:,:,t), names(observe_idx,2:3), names(missing_idx,2:3), sigma);
end

[ cov_est_denoise,fs ] = cov_kriging( cov_est, beta, lambda, Dims );

%%
for t = 1: nTasks   
    for  time = 1:nTime
    kriging_est{t}(:,time)  = cov_est_denoise(:,:,t)'/(W(:,:,t)) * series_partial{t}(:,time);
    end
end

err_RMSE = zeros(nTasks,1);
for t = 1:nTasks
    err_RMSE(t) = sqrt(norm(kriging_est{t} - series{t}(missing_idx,:),'fro')^2/(nTime*nMissing));
end
%%
sigma = 1e-1;
for t = 1: nTasks   
    for  time = 1:nTime
    kout = nwreg(cov_emp(:,:,t), names(observe_idx,2:3), names(missing_idx,2:3), sigma);
    kriging_est{t}(:,time) = kout'/W(:,:,t) * series_partial{t}(:,time);
    end
end

err_RMSE_emp = zeros(nTasks,1);
for t = 1:nTasks
    err_RMSE_emp(t) = sqrt(norm(kriging_est{t} - series{t}(missing_idx,:),'fro')^2/(nTime*nMissing));
end

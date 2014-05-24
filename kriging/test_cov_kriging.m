clear; clc;
genData_ClimateP3;

lambda = 2;
beta = 1;
sigma = 1e-3;
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
for t = 1: nTasks   
    kout = nwreg(W(:,:,t), names(observe_idx,2:3), names(missing_idx,2:3), sigma);
    for  time = 1:nTime
    kriging_est{t}(:,time) = kout'/(W(:,:,t)) * series_partial{t}(:,time);
    end
end

err_RMSE = zeros(nTasks,1);
for t = 1:nTasks
    err_RMSE(t) = sqrt(norm(kriging_est{t} - series{t}(missing_idx,:),'fro')^2/(nTime*nMissing));
end
%%
sigma = 1;
for t = 1: nTasks       
    kout = nwreg(cov_emp(:,:,t), names(observe_idx,2:3), names(missing_idx,2:3), sigma);
    for  time = 1:nTime
    kriging_est_emp{t}(:,time) = kout'/cov_emp(:,:,t) * series_partial{t}(:,time);
    end
end

err_RMSE_emp = zeros(nTasks,1);
for t = 1:nTasks
    err_RMSE_emp(t) = sqrt(norm(kriging_est_emp{t} - series{t}(missing_idx,:),'fro')^2/(nTime*nMissing));
end

%% metric learning
sigma = 1;
for t = 1: nTasks      
    kout = mlkernel(W(:,:,t), names(observe_idx,2:3), names(missing_idx,2:3));
    for  time = 1:nTime
    kriging_est_emp{t}(:,time) = kout'/W(:,:,t) * series_partial{t}(:,time);
    end
end

err_RMSE_emp = zeros(nTasks,1);
for t = 1:nTasks
    err_RMSE_emp(t) = sqrt(norm(kriging_est_emp{t} - series{t}(missing_idx,:),'fro')^2/(nTime*nMissing));
end

clear; clc;
genData_ClimateP3;

lambda = 1e-3;
beta = 1e-2;
Dims = [nObserve, nObserve, nTasks];
cov_emp = zeros(Dims);
time = 1;

for t = 1: nTasks
    X_t = series{t}(observe_idx,time)';
    cov_emp(:,:,t) = cov(X_t);
end

[ W,fs ] = cov_kriging( cov_emp, beta, lambda, Dims );
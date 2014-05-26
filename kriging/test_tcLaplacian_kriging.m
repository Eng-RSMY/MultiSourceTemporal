addpath(genpath('../'));
clear; clc; genData_ClimateP17;
lambda = 1;
beta = 2;
mu = 1e-5;
Dims = size(X);
sigma = 1e-2;
%%
Sim = sim_Gaussian(locations, sigma);
%%
[ W ] = tcLaplacian_kriging( X_Missing, Sim, lambda, beta, mu, Dims, idx_Missing);


%% evaluate
W_test = W(idx_Missing,1,:);
X_test = X( idx_Missing,1,:);
RMSE  = sqrt(norm_fro(W_test-X_test)^2/ numel(W_test));
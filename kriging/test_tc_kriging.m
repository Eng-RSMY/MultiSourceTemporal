addpath(genpath('../'));
clear; clc; genData_ClimateP17;
lambda = 1e-5;
beta = 2;
Dims = size(X);

%%
[ W ] = tc_kriging( X_Missing, lambda, beta, Dims, idx_Missing );


%% evaluate
W_test = W(idx_Missing(:,1),idx_Missing(:,2),:);
X_test = X( idx_Missing(:,1),idx_Missing(:,2),:);
RMSE  = sqrt(norm_fro(W_test-X_test)^2/ numel(W_test));
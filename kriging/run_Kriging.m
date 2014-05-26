clear;
clc;
load 'climateP17.mat';

nTasks = length(series);
[nLoc nTime] = size(series{1});



lambda = 1e-5;
beta = 2;
mu = 0.1;
sigma = 1e-2;
%%
Sim = sim_Gaussian(locations, sigma);
missing_rates = [0.1:0.1:1];
M = length(missing_rates);
tcLap_est = cell(M,1);
cokrig_est = tcLap_est;

idx_Missing = cell(M,1);
mtgp_est = tcLap_est;
time = 1;
for i = 1:M
    missing_rate  = missing_rates(i);
    [X_Missing, idx_Missing{i}] =  genMissingData_ClimateP17(series, missing_rate, time);
    tcLap= tcLaplacian_kriging( X_Missing,idx_Missing{i},Sim, lambda, beta, mu );
    tcLap_est{i} = squeeze(tcLap(idx_Missing{i},time,:));
    
    [cokrig_est{i}] = co_kriging (X_Missing, idx_Missing{i}, locations,time);
    cokrig_est{i} = cokrig_est{i}(:,3:end);

end

%%
RMSE_tcLap = zeros(1,M);
RMSE_cokrig= zeros(1,M); 

X = zeros([nLoc, nTime, nTasks]);
for t = 1:  nTasks
    X(:,:,t) = series{t};
end
for i = 1:M
    X_test = squeeze(X( idx_Missing{i},time,:));
    RMSE_tcLap(i)  = sqrt(norm_fro(tcLap_est{i}-X_test)^2/ numel(X_test));
    RMSE_cokrig(i)  = sqrt(norm_fro(cokrig_est{i}-X_test)^2/ numel(X_test));
end

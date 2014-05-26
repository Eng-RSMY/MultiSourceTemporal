clear;
clc;
load 'climateP17.mat';

nTasks = length(series);
[nLoc nTime] = size(series{1});



lambda = 1;
beta = 2;
mu = 1e-5;
Dims = size(X);
sigma = 1e-2;
%%
Sim = sim_Gaussian(locations, sigma);
missing_rates = [0:0.1:1];

tcLap_est = cell(11,1);
cokrig_est = tcLap_est;
mtgp_est = tcLap_est;
time = 1;
for i = 1:length(missing_rates)
    missing_rate  = missing_rates(i);
    [X_Missing, idx_Missing] =  genMissingData_Climate(series, missing_rate, time);
    tcLap_est{i} = tcLaplacian_kriging( X_Missing,idx_Missing,Sim, lambda, beta, mu, Dims );

end

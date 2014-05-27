clear;
clc;
load 'climateP17.mat';

nTasks = length(series);
[nLoc nTime] = size(series{1});



lambda = 1e-5;
beta = 2;
mu = 1e-3;
sigma = 3;
%%
Sim = sim_Haversine(locations, sigma);
Sim = Sim/max(Sim(:));
% missing_rates = [0.1:0.1:1];
mus = logspace(-2,0,10);
lambdas = logspace(-8,-5,3);
M = length(lambdas);
tcLap_est = cell(M,1);
cokrig_est = tcLap_est;
missing_rate =0.1;

mtgp_est = tcLap_est;
time = 1;
[X_Missing, idx_Missing] =  genMissingData_ClimateP17(series, missing_rate, time);

for i = 1:1
%     mu = mus(i);  
%     lambda = lambdas(i);
    tcLap_est{i}= tcLaplacian_kriging( X_Missing,idx_Missing,Sim, lambda, beta, mu );

%     [cokrig_est{i}] = co_kriging (X_Missing, idx_Missing{i}, locations,time);
%     cokrig_est{i} = cokrig_est{i}(:,3:end);
    disp(i);
end

%%
RMSE_tcLap = zeros(1,M);
RMSE_cokrig= zeros(1,M); 

X = zeros([nLoc, nTime, nTasks]);
for t = 1:nTasks
    X(:,:,t) = series{t};
end
for i = 1:1
    X_test = squeeze(X( idx_Missing,:,:));
    RMSE_tcLap(i)  = sqrt(norm_fro(tcLap_est{i}-X_test)^2/ numel(X_test));
%     RMSE_cokrig(i)  = sqrt(norm_fro(cokrig_est{i}-X_test)^2/ numel(X_test));
end

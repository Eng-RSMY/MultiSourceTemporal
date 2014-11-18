clear;
clc;
addpath(genpath('../'));
%load 'climateP17.mat';
% load 'climateP17_missIdx.mat';

%load 'climateP3.mat';
%load 'climateP3_missIdx.mat';

% load 'norm_4sq_small.mat'
% load 'fsq_missIdx.mat'

%load 'climateP4.mat'
%load 'climateP4_missIdx.mat'

% load 'yelp.mat'
% load 'yelp_missIdx.mat'

load 'dense_high_way_april.mat'
load 'idx_missing_dense.mat'


lambda = 1e-3;
beta = 2;
mu = 0.1;
sigma = 3;


nTasks = length(series);
[nLoc nTime] = size(series{1});

X = zeros([nLoc, nTime, nTasks]);

for t = 1:nTasks
    X(:,:,t) = series{t};
end
% locations = names(:,2:3);
% Sim = sim_Haversine(locations, sigma);
Sim = Lap;
Sim = Sim/max(Sim(:));
M = 22;

nMissing = 1;
%%
tcLap_est = cell(nMissing,1);
for i = 1:nMissing
    idx = idx_Missing(:,i);

    X_Missing = X;
    X_Missing(idx,:,:) = 0;

    tic
    tcLap_est{i}= tcLaplacian_kriging( X_Missing,idx,Sim, lambda, beta, mu );
    toc

%     [cokrig_est{i}] = co_kriging (X_Missing, idx_Missing{i}, locations,time);
%     cokrig_est{i} = cokrig_est{i}(:,3:end);
    disp(i);
end
save('tcLap_yelp.mat','tcLap_est');



%%
M = 22;
RMSE_tcLap = zeros(1,M);
RMSE_cokrig= zeros(1,M); 


for i = 1:nMissing
    idx = idx_Missing(:,i);
    X_test = X( idx,:,:);
    X_est = tcLap_est{1}(idx,:,:);
    RMSE_tcLap(i)  = sqrt(norm_fro(X_est-X_test)^2/ numel(X_test));
end
disp(mean(RMSE_tcLap(i)));

save('tcLap_yelp.mat','tcLap_est','RMSE_tcLap');
%%
load 'tcLap_yelp.mat'

idx = idx_Missing(:,1);

X_test = X( idx,:,:);
X_est = tcLap_est{1};

nonzero_idx = (X_test ~=0);
X_test_nonzero = X_test(nonzero_idx);
X_est_nonzero = X_est (nonzero_idx);

sqrt(norm(X_est_nonzero-X_test_nonzero, 'fro')^2/ numel(X_test_nonzero))./5


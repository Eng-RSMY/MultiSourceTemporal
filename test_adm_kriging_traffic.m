clear;
clc;
addpath(genpath('./'));

% load 'dense_highway_april.mat'
% load 'idx_missing_dense.mat'

load 'sparse_highway_april.mat'
load 'idx_missing_sparse.mat'

lambda = 1e2;
beta = 1;
mu = 20;
sigma = 0.01;

[nLoc, nTime, nTask] = size(series);
X = series;
Sim = sim_Haversine(latlng, sigma);
% Sim = Lap;
Sim = Sim/max(Sim(:));


num_fold = 10;
%%
maxIter = 50;
thres = 1e-6;
tcLap_est = cell(num_fold,1);
X_missing_list = cell(num_fold,1);
for i = 1:num_fold
    idx = logical(idx_missing(:,i));
    X_missing = X;
    X_missing(idx,:,:) = 0;
    X_missing_list{i} =  X_missing;
end

parfor fold_idx = 1:num_fold
    tic
    tcLap_est{fold_idx}= tcLaplacian_kriging( X_missing_list{fold_idx},logical(idx_missing(:,fold_idx)),Sim, lambda, beta, mu,...
                                              maxIter, thres);
    toc
    disp(fold_idx);
end

save('result/traffic/adm_sparse_highway.mat','tcLap_est');
fprintf('finish estimation\n');

%%

RMSE_tcLap = zeros(1,num_fold);

for i = 1:num_fold
    idx = logical(idx_missing(:,i));
    X_test = X( idx,:,:);
    X_est = tcLap_est{i};
    RMSE_tcLap(i)  = sqrt(norm_fro(X_est-X_test)^2/ numel(X_test));
end
disp(mean(RMSE_tcLap(i)));

save('result/traffic/adm_sparse_highway.mat','tcLap_est','RMSE_tcLap');
fprintf('finish evaluation\n');



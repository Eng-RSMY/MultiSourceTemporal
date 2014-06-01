clear;
clc;
addpath(genpath('.'));
load 'climateP17.mat';
load 'climateP17_missIdx.mat';

lambda = 1e-5;
beta = 2;
mu = 1e-3;
sigma = 3;


nTask = length(series);
[nLoc nTime] = size(series{1});

X = zeros([nLoc, nTime, nTask]);

for t = 1:nTask
    X(:,:,t) = series{t};
end

M = 2;
nMissing = 13;

mtgp_est = cell(M,1);
for i = 1:M
    mtgp_est{i} = zeros(nMissing, nTime, nTask);
end

for i = 1:M
    idx = idx_Missing(:,i);

    X_Missing = X;
    X_Missing(idx,:,:) = 0;

    for time  = 1:nTime
         X_Missing_t =squeeze(X_Missing(:,time,:));
         est_val = mtgp_kriging (X_Missing_t, idx, locations);
        mtgp_est{i}(:,time,:) = est_val;
    end
    disp(i);
end
save('mtgp_ClimateP17.mat','mtgp_est');



%%
RMSE_mtgp= zeros(1,M); 


for i = 1:M
    idx = idx_Missing(:,i);
    X_test = X( idx,:,:);
    RMSE_mtgp(i)  = sqrt(norm_fro(mtgp_est{i}-X_test)^2/ numel(X_test));
 end

save('mtgp_ClimateP17.mat','mtgp_est','RMSE_mtgp');

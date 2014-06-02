clear;
clc;
addpath(genpath('.'));
load 'climateP3.mat';
load 'climateP3_missIdx.mat';
locations = names(:,2:3);

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

M = 10;
nMissing = 10;

cokrig_est = cell(M,1);
for i = 1:M
    cokrig_est{i} = zeros(nMissing, nTime, nTask);
end

for i = 1:M
    idx = idx_Missing(:,i);

    X_Missing = X;
    X_Missing(idx,:,:) = 0;

    for time  = 1:nTime
         X_Missing_t =squeeze(X_Missing(:,time,:));
         est_val = ordinary_kriging (X_Missing_t, idx, locations);
        cokrig_est{i}(:,time,:) = est_val(:,3:end);
    end
    disp(i);
end
save('ordinary_ClimateP3.mat','cokrig_est');
% save('universal_ClimateP17.mat','cokrig_est');



%%
RMSE_cokrig= zeros(1,M); 


for i = 1:M
    idx = idx_Missing(:,i);
    X_test = X( idx,:,:);
    RMSE_cokrig(i)  = sqrt(norm_fro(cokrig_est{i}-X_test)^2/ numel(X_test));
 end

save('ordinary_ClimateP3.mat','cokrig_est','RMSE_cokrig');


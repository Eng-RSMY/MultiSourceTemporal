% addpath(genpath('../'));
%  genData_ClimateP3;
 
clear; clc;
load 'climateP17.mat'

D = 2;
nTasks = length(series);
[nLocs , nTime] = size(series{1});


missing_idx = [1:10];
nMissing = length(missing_idx);
nObserve = nLocs-nMissing;
observe_idx = setdiff(1:nLocs,missing_idx);


series_partial = cell(nTasks,1);
for t = 1:nTasks
    series_t = series{t};
    series_partial{t} = series_t(observe_idx,:);
end


time = 1;
kriging_est = zeros(nMissing,nTasks);
% construct xtrain and ytrain
covfunc_x = 'covSEard';
xtrain = locations;
xtest =  locations(missing_idx, :);


ytrain = [];
idx_train = [];
for t = 1:nTasks   
    ytrain = [ytrain; series_partial{t}(:,time)];
    idx_train = [idx_train, (observe_idx-1)*nTasks+t];
end
% idx_train and ytrain should be same size
[ kriging_est] = multitask_GP(covfunc_x ,xtrain, ytrain , idx_train , xtest, nLocs,nTasks,D);



%% evaluate performance
err_RMSE_GP = 0;
X_gt = zeros(nMissing, nTasks);


for t = 1: nTasks
    X_gt (:,t) = series{t}(missing_idx,time);
end

    err_RMSE_GP = err_RMSE_GP +  sqrt(norm_fro(kriging_est-X_gt)^2/numel(X_gt));


disp(err_RMSE_GP);


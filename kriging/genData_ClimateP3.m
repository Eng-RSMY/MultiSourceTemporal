% create missing data points, use base functions for covariance
clc; clear;
load 'climateP3.mat'
missing_idx = [20:10:100];
observe_idx = setdiff(1:108,missing_idx);
nTasks = length(series);

series_partial = cell(nTasks,1);
for t = 1:nTasks
    series_t = series{t};
    series_partial{t} = series_t(observe_idx,:);
end

%%
% compute the covariance for the paritial index
% 1. empirical covariance -- past time samples
cov_task = cell(nTasks,1);
for t = 1:nTasks
    cov_task{t} = cov(series_partial{t}');
end

cov_missing = series_partial{}
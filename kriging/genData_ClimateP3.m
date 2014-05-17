% create missing data points, 
clear; clc;
load 'climateP3.mat'

nTasks = length(series);
[nLoc , nTime] = size(series{1});

nMissing = 10;
missing_idx = randi([1,nLoc], 1,nMissing);
observe_idx = setdiff(1:108,missing_idx);


series_partial = cell(nTasks,1);
for t = 1:nTasks
    series_t = series{t};
    series_partial{t} = series_t(observe_idx,:);
end


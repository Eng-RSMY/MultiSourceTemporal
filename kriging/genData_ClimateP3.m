% create missing data points, 
clear; clc;
load 'climateP3.mat'

nTasks = length(series);
[nLocs , nTime] = size(series{1});


missing_idx = [1:5:nLocs];
nMissing = length(missing_idx);
nObserve = nLocs-nMissing;
observe_idx = setdiff(1:nLocs,missing_idx);


series_partial = cell(nTasks,1);
for t = 1:nTasks
    series_t = series{t};
    series_partial{t} = series_t(observe_idx,:);
end


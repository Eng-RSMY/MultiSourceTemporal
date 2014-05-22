
clear; clc; genData_ClimateP3;

% construct xtrain and ytrain
covfunc_x = 'covSEard';
xtrain = names(:,2:3);
ytrain = [];
for t = 1:nTasks   
    ytrain = [ytrain, series_partial{t}(:,1)'];
end
idx_train = [observe_idx*2, observe_idx*2-1];
[ Ypred ] = multitask_GP(covfunc_x ,xtrain, ytrain ,nLocs,nTasks,2, idx_train);


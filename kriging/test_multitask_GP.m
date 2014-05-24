% addpath(genpath('../'));
% clear; clc; genData_ClimateP3;
nTime = 1;
kriging_est = zeros(nMissing,nTasks,nTime);
% construct xtrain and ytrain
covfunc_x = 'covSEard';
xtrain = names(:,2:3);
xtest =  names(missing_idx, 2:3);

for time = 1:nTime
    ytrain = [];
    for t = 1:nTasks   
        ytrain = [ytrain; series_partial{t}(:,time)];
    end
    idx_train = [observe_idx*nTasks, observe_idx*nTasks-1, observe_idx*nTasks-2];% idx_train and ytrain should be same size
    [ kriging_est(:,:,time) ] = multitask_GP(covfunc_x ,xtrain, ytrain , idx_train , xtest, nLocs,nTasks,2);
end

kriging_est = permute(kriging_est,[1,3,2]); 
% save('../result/climate/multiTask_GP_climateP3.mat','kriging_est');
%% evaluate performance
err_RMSE_GP = zeros(nTasks,1);

for t = 1:nTasks
    err_RMSE_GP(t) = sqrt(norm(kriging_est(:,:,t) - series{t}(missing_idx,time),'fro')^2/(nTime*nMissing));
end

disp(err_RMSE_GP);
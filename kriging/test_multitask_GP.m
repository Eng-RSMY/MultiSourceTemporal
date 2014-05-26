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


%% evaluate performance
err_RMSE_GP = 0;

err_RMSE_GP = err_RMSE_GP +  sqrt(norm_fro(x0s(:,2+t:end) -x(missing_idx,2+t:end))^2/numel(x0s(:,2+t:end)));

disp(err_RMSE_cokriging);


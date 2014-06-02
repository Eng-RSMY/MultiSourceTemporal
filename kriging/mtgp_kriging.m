function [ X_est ] = mtgp_kriging( X, idx_Missing, locations )
%MTGP_KRIGING Summary of this function goes here
%   Detailed explanation goes here

% construct xtrain and ytrain
[nLoc, nTask ] = size(X);
D = 2;

covfunc_x = 'covSEard';

observe_idx = setdiff(1:nLoc,idx_Missing);

xtrain = locations;
xtest =  locations(idx_Missing, :);


ytrain = [];
idx_train = [];
for t = 1:nTask  
    ytrain = [ytrain; X(observe_idx,t)];
    idx_train = [idx_train, (observe_idx-1)*nTask+t];
end
% idx_train and ytrain should be same size
[ X_est] = multitask_GP(covfunc_x ,xtrain, ytrain , idx_train , xtest, nLoc,nTask,D);





end


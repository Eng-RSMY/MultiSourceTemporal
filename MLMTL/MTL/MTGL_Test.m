function [ Quality ] = MTGL_Test( X_test, Y_test, W )
%MTGL_TEST Summary : X: 1 x nTasks, each nSample x nDim matrix
% Y: 1x nTasks cell, W: weight matrix
% Quality: Structure of RMSE, NRMSE, Rank, Time
%   Detailed explanation goes here


numTask = length(X_test);
nSample = size(X_test{1},1);
MSE = zeros(numTask,1);
NMSE = zeros(numTask,1);
for i = 1:numTask
    MSE(i) = sqrt(norm(Y_test{i} - X_test{i}*W(:,i))^2/nSample);
    NMSE(i) = MSE(i) / (norm(Y_test{i})^2);
end

Quality.RMSE = sqrt(mean(MSE));
Quality.NRMSE = sqrt(mean(NMSE));

Quality.rank = rank(W);

end


function MSE = MLMTL_Test(X_test,Y_test, W)
%MLMTL_TEST Summary of this function goes here
%   Detailed explanation goes here

numTask = length(X_test);
nSample = size(X_test{1},2);
error = zeros(numTask,1);
for i = 1:numTask
    error(i) = norm(Y_test{i} - X_test{i}'*W(:,i))^2/nSample;
end

MSE = mean(error);
fprintf('Mean Square Error: %d', MSE);


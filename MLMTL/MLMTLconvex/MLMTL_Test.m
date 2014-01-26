function Quality = MLMTL_Test(X_test,Y_test, W)
%MLMTL_TEST Summary of this function goes here
%   Detailed explanation goes here

numTask = length(X_test);
nSample = size(X_test{1},2);
MSE = zeros(numTask,1);
for i = 1:numTask
    MSE(i) = norm(Y_test{i} - X_test{i}'*W(:,i))^2/nSample;
end


Z =0;
for i = 1:numTask
    Z = Z+ norm(Y_test{i})^2;
end

Z = Z/(nSample * numTask);

Quality.RMSE = sqrt(mean(MSE));
Quality.NRMSE = sqrt(mean(MSE)/Z);

Quality.Rank = rank(W);
%fprintf('Mean Square Error: %d', MSE);


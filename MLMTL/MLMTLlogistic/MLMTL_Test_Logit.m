function [ Quality ] = MLMTL_Test_Logit(X_test, Y_test, W )
%MLMTL_LOGIT_TEST Summary : classification prection
%   Detailed explanation goes here


nTasks = length(X_test);
[P,N] = size(X_test{1});
nTrue = 0;
for t = 1 : nTasks
    y =  double(sigmoid(W(:,t) , X_test{t})>0.5);
    nTrue = nTrue + sum(double(y==Y_test{t}));
end

Err = 1-  nTrue/ (nTasks * N);
Quality.RMSE = Err;




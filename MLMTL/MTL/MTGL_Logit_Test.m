function [ Quality ] = MTGL_Logit_Test( X_test, Y_test, W  )
%MTGL_LOGIT_TEST Summary of this function goes here
%   Detailed explanation goes here
nTasks = length(X_test);
[P,N] = size(X_test{1});
nTrue = 0;
for t = 1 : nTasks
    y =  sign(X_test{t}*W(:,t) );
    nTrue = nTrue + sum(double(y==Y_test{t}));
end

Err = 1-  nTrue/ (nTasks * N);
Quality.RMSE = Err; % for code compadability
Quality.Rank = rank(W);

end


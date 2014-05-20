%function [ W_r ] = solveW_gradDes( W, X, eta, maxIter )
%SOLVEW_GRADDES Summary: use gradient descend to solve the W_t task t
%   Detailed explanation goes here: W: Cholesky factor, X data

nSamples = size(X,1);
for iter = 1: maxIter
    grad = 2*nSamples*pinv(W') -  (W*W')\X'*X/(W*W')*2*W; % should be pseudo-inverse
    W  = W - eta*grad;
    disp(['iter ' int2str(iter)]);
end



%end


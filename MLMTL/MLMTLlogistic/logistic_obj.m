function [ L ] = logistic_obj(X,Y,w, CbetaB_t,beta, nModes)
%MLMTL_LOGITOBJ Log likelihood of the objective function
%  X: P x N matrix
%  Y: N x 1 vector
%  w: P x 1 vector

[P,N] = size(X);

L = 0;
logSum = 0;
for n = 1:N
    logSum = logSum + log(1+ exp(X(:,n)'* w));
end

L = logSum - Y'* X'*w + CbetaB_t'*w + beta/2*nModes*w'*w;

end


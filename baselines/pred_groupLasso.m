function [ x history ] = pred_groupLasso( series, nLag, lambda)
%PREDICT_GL Summary of this function goes here
%   Detailed explanation goes here
global verbose;
nVar  = size(series{1},1);
nType = size(series,1);

rho = 0.1;
alpha = 0.1;

partition = [nLag, nLag, nLag];
  
for  t = 1:nType
    if verbose; fprintf('#Type %d', t); end;
    A(:,(t-1)*nLag+1:t*nLag) = series{t}(:,1:nLag);
end

b = zeros(nVar,1);

[x history] = group_lasso(A, b,lambda, partition, rho, alpha);
     

end


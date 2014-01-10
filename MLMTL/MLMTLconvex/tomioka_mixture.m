function [X Z ] = tomioka_mixture( X0 , Y, beta, gamma)
%TOMIOKA_MIXTURE Summary of this function goes here
% Input
%   X0: initial tensor X0 = Z_1+Z_2+...Z_N
%   Y = ground truth tensor
%  gamma : regularizer paramter on the nucliner norm
% Output
%   Z: 1 x nModes cell, Z_1, Z_2.. Z_N
sz = Y.size;
nModes  = length(sz);
Z = cell(1, nModes);
yy = double(Y);
yy = yy(:);


ind = 1:prod(sz);
ind = ind';
[I,J,K]=ind2sub(sz,ind);
lambda = nModes^2/beta;
eta = 1;
tol = 1e-3;
verbose = 0;

[X_r,Z_r,~,~]=tensormix_adm(double(X0), {I,J,K}, yy, lambda, gamma, tol, verbose);

for i = 1:nModes
    Z{i} = tensor(Z_r{i},sz);
end

X = tensor(X_r);

end


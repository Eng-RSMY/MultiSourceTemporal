function [W , tensorW ] = MLMTL_Tucker( X, Y, Ps, alpha )
%TUCKER Summary of this function goes here
%   Detailed explanation goes here: implementation of the Tucker product
%   algorithm in Multilinear Multitask Learning
% TBD: solve the inf problem in the output
global verbose;
verbose = 0;
maxIter = 8;

nDims = length(Ps);
nTasks = prod(Ps(2:end));


Ks = [];
for d = 1:nDims
    Ks = [Ks min(Ps(d),10)];
end

A = cell(1,nDims);
for d = 1:nDims
    A{d} = rand(Ps(d),Ks(d));
end

G = tensor(rand(Ks(1),Ks(2),Ks(3)));
G_1=tenmat(full(G), 1);
G_1=G_1.data;
f_A = cell(nDims, 1);
etaG =  1e-6;
etaA1 = 1e-3;
etaA2 = 1e-4;
etaA3 = 1e-4;

for iter = 1:maxIter

    % minimize over G

    [G_1 f_G_1 etaG] = grad_descent_G(G_1, A, X, Y,etaG, alpha);
    etaG = etaG /10;

    % minimize over A1
    [A{1} f_A{1} etaA1] = grad_descent_A1(G_1, A, X, Y,etaA1, alpha);
    etaA1 = etaA1 /10;
    % minimize over An

    [A{2},f_An, etaA2] = grad_descent_An(G_1,A,X,Y,2 , etaA2,alpha);
    f_A{2} = f_An;
    etaA2 = etaA2/10;
    
    [A{3},f_An ,etaA3] = grad_descent_An(G_1,A,X,Y,3 , etaA3, alpha);
    f_A{3} = f_An;
    etaA3 = etaA3/10;


end

outer_prod = A{nDims};
for d = fliplr(2:nDims-1)
    outer_prod = kron(outer_prod,A{d});
end
W  = A{1}*G_1 *outer_prod';

tensorW = tensor(reshape(W, Ps));


end

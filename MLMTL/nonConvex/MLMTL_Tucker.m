function [W , tensorW ] = MLMTL_Tucker( X, Y, Ps )
%TUCKER Summary of this function goes here
%   Detailed explanation goes here: implementation of the Tucker product
%   algorithm in Multilinear Multitask Learning
global verbose;
verbose = 0;
maxIter = 10;

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

G = tensor(-1*rand(Ks(1),Ks(2),Ks(3)));
G_1=tenmat(full(G), 1);
G_1=G_1.data;
f_A = cell(nDims, 1);

for iter = 1:maxIter

    % minimize over G
    fprintf('Minimize over G\n');
    [G_1 f_G_1] = grad_descent_G(G_1, A, X, Y,1e-4);

    % minimize over A1
    fprintf('Minimize over A1\n');
    [A{1} f_A{1}] = grad_descent_A1(G_1, A, X, Y,1e-4);

    % minimize over An

    fprintf('Minimize over A2\n');
    [A{2},f_An] = grad_descent_An(G_1,A,X,Y,2 , 1e-4);
    f_A{2} = f_An;
    
    fprintf('Minimize over A3\n');
    [A{3},f_An] = grad_descent_An(G_1,A,X,Y,3 , 1e-3);
    f_A{3} = f_An;


end

W = A{1}*G_1;
outer_prod = A{nDims};
for d = fliplr(2:nDims-1)
    outer_prod = kron(outer_prod,A{d});
end
W  = W*outer_prod;

tensorW = tensor(reshape(W, Ps));


end

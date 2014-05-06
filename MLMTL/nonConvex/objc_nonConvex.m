function [ objc_val ] = objc_nonConvex(G_1, A, X, Y )
%objc_nonConvex Summary of this function goes here
%   Detailed explanation goes here

alpha = 0.5;
nTasks = length(Y);
nSamples = size(A{1},2);
nDims = length(A);

outer_prod = A{nDims};
for d = fliplr(2:nDims-1)
    outer_prod = kron(outer_prod,A{d});
end

W_1 =  A{1}*G_1 *outer_prod';
objc_val = 0;
for t = 1:nTasks
     objc_val= objc_val +norm(X{t}'*W_1(:,t)- Y{t})^2 + alpha*norm(G_1,'fro')^2 ;
end



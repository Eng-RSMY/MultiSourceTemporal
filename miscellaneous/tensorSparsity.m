function [ sparsity ] = tensorSparsity( W, thres )
%TENSORSPARSITY Summary of this function goes here
%   Detailed explanation goes here


W(W<thres) =0;


sparsity = length(find(W==0)) /numel(W);

end


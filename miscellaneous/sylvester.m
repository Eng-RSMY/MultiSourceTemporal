function [ X ] = sylvester( A,B,C )
%SYLVESTER Summary of this function goes here
%   Detailed explanation goes here

n = size(A,1);
m = size(B,1);
X = ( kron(eye(m),A) + kron(B',eye(n)) ) \C(:);
X = reshape(X,[n,m]);

end


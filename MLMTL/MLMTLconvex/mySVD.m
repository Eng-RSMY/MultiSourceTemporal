function [ u l v ] = mySVD( A )
%MYSVD Summary of this function goes here
%   Detailed explanation goes here

[nRows, nCols]=size(A);
if nRows>=nCols
    [u l v]=svd(A);
    return
end
AA=A*A';
[u l2 v2]=svd(AA);
l=diag(sqrt(diag(l2)));
invl2=diag(1./sqrt(diag(l2)));
v=(invl2*u'*A)';

end


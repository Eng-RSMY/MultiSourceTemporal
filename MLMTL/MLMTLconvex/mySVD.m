function [ u l v ] = mySVD( A )
%MYSVD Summary of this function goes here
%   Detailed explanation goes here
% TBD: add try/catch pair

[nRows, nCols]=size(A);



if nRows>=nCols
    [u l v]=svd(A);
    return
end
AA=A*A';

% force AA symetric
AA = (AA+AA')/2;


[u l2 v2]=svd(AA);



l=diag(sqrt(diag(l2)));
invl2=diag(1./sqrt(diag(l2)));
v=(invl2*u'*A)';

end


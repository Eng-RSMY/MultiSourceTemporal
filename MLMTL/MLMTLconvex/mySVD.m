function [ u l v ] = mySVD( A )
%MYSVD Summary of this function goes here
%   Detailed explanation goes here
% TBD: add try/catch pair

[nRows, nCols]=size(A);

% check input inf
if(sum(isinf(A))) >0
    warning('mySVD: input matrix has inf element, set to zero\n');
    A(isinf(A)) =0;
end
    
% check input nan
if (sum(isnan(A)))>0
    warning('mySVD: input matrix has nan element, set to zero\n');
    A(isnan(A)) = 0;
end

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


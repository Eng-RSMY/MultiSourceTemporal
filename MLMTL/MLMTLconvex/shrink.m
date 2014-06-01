function M = shrink(A, s)
% [U L V]=mySVD(A);
[U L V] = svd(A);
eig=diag(L)-s;
eig(eig<0)=0;
eigM=diag(eig);
L(1:size(eigM,1), 1:size(eigM,2))=eigM;
M=U*L*V';
end


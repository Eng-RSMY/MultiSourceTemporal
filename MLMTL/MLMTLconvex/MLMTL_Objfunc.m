function L = MLMTL_Objfunc(X,Y,W,B,C, lambda,beta)
%MLMTL_OBJFUNC Summary of this function goes here
%   X: nTasks cell, each cell, nDim * nSample
%   Y: nTasks cell, each cell, nSample * 1
%   W: tensor estimated, B auxiliary tensors, nModes cell
%   L: objective function value:
%|| Y- X*W ||^2 + \lambda \sum_k \|B^_{(k)}\|_1

F = 0;
nTasks = length(X);
nModes = ndims(W);
dimModes = size(W);
[nDim, nSample] = size(X{1});
matW = zeros(nDim, nTasks);
matW = tenmat(W, 1);
matW = matW.data;
for t = 1:nTasks
     F = F + norm(Y{t} - X{t}'*matW(:,t))^2;
end

R = 0;
for n = 1:nModes
    B_n = B{n};
    matB = tenmat(B_n, n);
    matB = matB.data;
    R = R + rank(matB);
end

L = F + lambda*R;
sumB = tenzeros(dimModes);
if( iscell(C)) % Convex
    for n = 1:nModes
        B_n = double(B{n});
        C_n = double(C{n});
        L = L - C_n(1:end)*(matW(1:end)-B_n(1:end))';
        L = L + beta/2* norm(matW(1:end)-B_n(1:end))^2;
    end
    

else
     
     for n = 1:nModes
         sumB= sumB +B{n};
     end
     sumB = double(1/nModes*sumB);
     C = double(C);
     L = L - C(1:end)*(matW(1:end)-sumB(1:end))';
     L = L + beta/2 * norm(matW(1:end)-sumB(1:end))^2;
        
end




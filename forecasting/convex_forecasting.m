function [ output_args ] = convex_forecasting( X,  Sim, lambda, beta, mu )
%CONVEX_FORECASTING Summary of this function goes here
%   Detailed explanation goes here

global verbose;
verbose = 1;
maxIter = 500;

Dims  = size(X);
nModes = length(Dims);
nLoc  = Dims(1);
nTask = Dims(3);
thres = 1e-6;

% intialize 
W = zeros(Dims);
Z = cell(nModes,1);
C = cell(nModes,1);


for n = 1: nModes
    Z{n} = zeros(Dims);
    C{n} = zeros(Dims);
end


% contruct Laplacian

L = diag(sum(Sim, 2)) - Sim;

fs =[];
fval_old = obj_cov_kriging(X, W, Z, C, beta, lambda);
for iter = 1:maxIter
    CnSum = zeros(Dims);
    ZnSum = zeros(Dims);
    for n = 1:nModes
        CnSum = CnSum +  C{n};
        ZnSum = ZnSum + Z{n};
    end
    % Solve W 
    for t = 1:nTask
        W(:,:,t) = ((1+nModes*beta)* eye(nLoc)+ mu*2*L)\( X(:,:,t)+ CnSum(:,:,t)+ beta* ZnSum(:,:,t) ) ;

    end
    % Optimizing over B    
    for n=1:nModes    
        W_n= unfld(W, n);
        Cn_n = unfld(C{n},n);
        Zn_n=shrink(W_n-1/beta*Cn_n, lambda/beta);
        Z{n} = fld2(Zn_n,n, Dims);
    end

     % Optimizing over C  
    for n=1:nModes     
        C{n}=C{n} -  beta*(W-Z{n});
    end
    
    fval = obj_cov_kriging(X, W, Z, C, beta, lambda);
    if(abs(fval-fval_old)/fval < thres)
        break;
    end
    fval_old = fval;
    fs = [fs,fval];
    if verbose
        disp(iter);
    end
end

W = W(idx_Missing,:,:);

end

function val =  obj_cov_kriging(X, W, Z, C, beta, lambda)
val = 0;
nTasks = size(W,3);
nModes = ndims (W);
for t = 1:nTasks
    val = val + 0.5*norm(W(:,:,t)-X(:,:,t),'fro')^2;
end
for n = 1:nModes
    tmp = (W-Z{n});
    val = val -  C{n}(:)'* tmp(:);
    
    for t = 1:nTasks
        val = val + beta/2 * norm(W(:,:,t)-Z{n}(:,:,t),'fro')^2;
    end
    
    
     Zn_n = unfld(Z{n},n);
     S = svd(Zn_n);
     val = val + lambda * sum(S);
end

end


function [ output_args ] = convex_forecasting( X,  Sim, lambda, beta, mu, nLag )
%CONVEX_FORECASTING Summary of this function goes here
%   Detailed explanation goes here?X P x T x M

global verbose;
verbose = 1;
maxIter = 500;

Dims  = size(X);
nModes = length(Dims);
nLoc  = Dims(1);
nTime = Dims(2);
nTask = Dims(3);
thres = 1e-6;

% intialize 
Dims_bar = [nLoc, nLoc*nLag, nTask];
W = zeros(Dims_bar);
Z = cell(nModes,1);
C = cell(nModes,1);


for n = 1: nModes
    Z{n} = zeros(Dims_bar);
    C{n} = zeros(Dims_bar);
end

% construct X_bar
Xbar = zeros(nLoc*nLag, nTime-nLag, nTask);
Y = zeros(nLoc,nTime-nLag, nTask);
for t = 1:nTasks
    for l = 1:nLag
        Xbar((l-1)*nLoc+1:l*nLoc,: ,t) = X(:,l:nTime-nLag+l,t);       
    end
    Y(:,:,t) = X(:,nLag+1:nTime,t);
end


% contruct Laplacian

L = diag(sum(Sim, 2)) - Sim;

fs =[];
fval_old = obj_forecasting(Xbar,Y, W, L, Z, C, beta, lambda);
for iter = 1:maxIter
    CnSum = zeros(Dims);
    ZnSum = zeros(Dims);
    for n = 1:nModes
        CnSum = CnSum +  C{n};
        ZnSum = ZnSum + Z{n};
    end
    % Solve W 
    for t = 1:nTask
        W(:,:,t) = (Xbar*Xbar'+ nModes*beta* eye(nLoc)+ mu*2*L*(Xbar*Xbar'))\(Xbar(:,:,t)*Y(:,:,t)+ CnSum(:,:,t)+ beta* ZnSum(:,:,t) ) ;

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
    
    fval = obj_forecasting(Xbar, Y, W,L, Z, C, beta, lambda);
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

function val =  obj_forecasting(X, Y, W, L,Z, C, beta, lambda)
val = 0;
nTasks = size(W,3);
nModes = ndims (W);
for t = 1:nTasks
    val = val + 0.5*norm(W(:,:,t)*X-Y(:,:,t),'fro')^2;
    val = val  + trace(W(:,:,t)*X(:,:,t)'*L);
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


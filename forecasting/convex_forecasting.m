function [ W fs] = convex_forecasting( X,  Sim, lambda, beta, mu, nLag )
%CONVEX_FORECASTING Summary of this function goes here
%   Detailed explanation goes here?X P x T x M

global verbose;
verbose = 1;
maxIter = 100;

[nLoc, nTime , nTask]  = size(X);
Dims =  [nLoc, nLoc*nLag, nTask];
nModes = length(Dims);
thres = 1e-3;

% intialize 

W = zeros(Dims);
Z = cell(nModes,1);
C = cell(nModes,1);


for n = 1: nModes
    Z{n} = zeros(Dims);
    C{n} = zeros(Dims);
end

% construct X_bar
Xbar = zeros(nLoc*nLag, nTime-nLag, nTask);
Y = zeros(nLoc,nTime-nLag, nTask);
for t = 1:nTask
    for l = 1:nLag
        Xbar((l-1)*nLoc+1:l*nLoc,: ,t) = X(:,nLag+1-l:nTime-l,t);       
    end
    Y(:,:,t) = X(:,nLag+1:nTime,t);
end


% contruct Laplacian

L = diag(sum(Sim, 2)) - Sim;

A = ( mu*L + eye(nLoc)) \( nModes*beta *eye(nLoc))  ;
B = zeros(nLoc*nLag,nLoc*nLag,nTask);
for t = 1:nTask
    B(:,:,t) = Xbar(:,:,t)*Xbar(:,:,t)';
end

fs =[];
fval_old = obj_forecasting( Xbar , Y, W, L, Z, C, beta, lambda);
for iter = 1:maxIter
    CnSum = zeros(Dims);
    ZnSum = zeros(Dims);
    for n = 1:nModes
        CnSum = CnSum +  C{n};
        ZnSum = ZnSum + Z{n};
    end
    % Solve W : nLoc X  nLoc*nLag X nTask
    for t = 1:nTask
            K  = ( mu*L + eye(nLoc)) \(Y(:,:,t)*Xbar(:,:,t)'+ CnSum(:,:,t)+ beta* ZnSum(:,:,t));
            W(:,:,t) = sylvester(A ,B(:,:,t), K);
%             W(:,:,t) = (Xbar*Xbar'+ nModes*beta* eye(nLoc*)+ mu*2*L*(Xbar*Xbar'))\(Y(:,:,t)*Xbar(:,:,t)'+ CnSum(:,:,t)+ beta* ZnSum(:,:,t) ) ;

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
    
    fval = obj_forecasting( Xbar, Y, W, L, Z, C, beta, lambda);
    if(abs(fval-fval_old)/fval < thres)
        break;
    end
    fval_old = fval;
    fs = [fs,fval];
    if verbose
        disp(iter);
    end
end

end

function val =  obj_forecasting(X, Y, W, L,Z, C, beta, lambda)
val = 0;
nTasks = size(W,3);
nModes = ndims (W);
for t = 1:nTasks
    X_est = W(:,:,t)*X(:,:,t);
    val = val + 0.5*norm(X_est-Y(:,:,t),'fro')^2;    
    val = val  + 0.5* trace(X_est'*L*X_est);
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


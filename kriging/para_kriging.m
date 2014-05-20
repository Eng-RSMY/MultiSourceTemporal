function W = para_kriging(X,beta, Dims)
% parameterize the covariance matrix and learn from the data
% assume fixed rank kriging: C = WW'
% solve the problem : min loss(W), sjt \sum W_(n) < r: ADMM solver



maxIter = 20;
eta = 0.2;
nSamples = size(X{1},1);
nTasks = length(X);
nModes = length(Dims);

% intialize 
W = rand(Dims);
Z = cell(nModes,1);
C = cell(nModes,1);

for n = 1: nModes
    Z{n} = zeros(Dims);
    C{n} = zeros(Dims);
end



for iter = 1:maxIter
    CnSum = zeros(Dims);
    for n = 1:nModes
        CnSum = CnSum +  C{n};
    end
% Solve W with gradient descend 
    for t = nTasks
        W_t = W(:,:,t);
        X_t = X{t};
        for GDiter = 1:maxIter
             
            grad = 2*nSamples*pinv(W_t') -  (W_t*W_t')\X_t'*X_t/(W_t*W_t')*2*W_t; 
            grad = grad + beta * ( CnSum (:,:,t) + Z{n}(:,:,t)  ) ;
            grad = grad + nModes * beta * W(:,:,t);
            W_t= W_t- eta*grad;
        end
        W(:,:,t)  = W_t;

    end
    
    % Optimizing over B    
    for n=1:nModes    
        W_n= unfld(W, n);
        Cn_n = unfld(C{n},n);
        Zn_n=shrink(W_n-1/beta*Cn_n, 1/beta);
        Z{n} = fld2(Zn_n,n, Dims);
    end
    
     % Optimizing over C   
    for n=1:nModes     
        C{n}=C{n}-beta*(W-Z{n});
    end
end
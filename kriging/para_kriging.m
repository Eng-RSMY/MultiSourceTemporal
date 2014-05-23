function [W fs] = para_kriging(X,beta,lambda, Dims)
% parameterize the covariance matrix and learn from the data
% assume fixed rank kriging: C = WW'
% solve the problem : min loss(W), sjt \sum W_(n) < r: ADMM solver



maxIter = 200;
maxGDIter  = 50;
eta = 1e-6;
nSamples = size(X{1},2);
nTasks = length(X);
nModes = length(Dims);
thres = 1e-3;


% intialize 
W = rand(Dims);
Z = cell(nModes,1);
C = cell(nModes,1);

for n = 1: nModes
    Z{n} = zeros(Dims);
    C{n} = zeros(Dims);
end

fs =[];

for iter = 1:maxIter
    CnSum = zeros(Dims);
    ZnSum = zeros(Dims);
    for n = 1:nModes
        CnSum = CnSum +  C{n};
        ZnSum = ZnSum + Z{n};
    end
% Solve W with gradient descend 
    for t = 1:nTasks
        f = zeros(1, maxGDIter);
        W_t = W(:,:,t);
        X_t = X{t};
        f_old =  W_obj_val(W_t, X_t, CnSum(:,:,t), ZnSum(:,:,t), beta, nModes);
        for GDiter = 1:maxGDIter
             
            grad = -2*nSamples*pinv(W_t) + ( X_t*X_t' )*W_t+ W_t* (X_t *X_t'); 
            grad = grad - ( CnSum (:,:,t) + beta* ZnSum(:,:,t)  ) ;
            grad = grad + nModes * beta * W(:,:,t);
            W_t= W_t- eta*grad;
            f_new =  W_obj_val(W_t, X_t, CnSum(:,:,t), ZnSum(:,:,t), beta, nModes);
            f(GDiter) = f_new;
            if(abs((f_new - f_old)/f_old ) < thres)
                break;
            end
        end
        fs = [fs;f];
        W(:,:,t)  = W_t;

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
end
end

function val = W_obj_val(W, X, CnSum, ZnSum, beta, nModes)
    nSamples = size(X,2);
    val = trace( (W*W')* (X*X'))- nSamples * log(det(W*W')) ;
    val = val - trace( (CnSum+ beta * ZnSum)' * W )+ nModes * beta/2 * norm(W,'fro');
end
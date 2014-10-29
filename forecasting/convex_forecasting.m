function [ W fs] = convex_forecasting( X,  Sim, lambda, beta, mu, nLag )
%CONVEX_FORECASTING Summary of this function goes here
%   Detailed explanation goes here?X P x T x M

global verbose;
verbose = 0;
maxIter = 250;

[nLoc, nTime , nTask]  = size(X);
Dims =  [nLoc, nLoc*nLag, nTask];
nModes = length(Dims);
thres = 1e-4;

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

% A = ( mu*L + eye(nLoc)) \( nModes*beta *eye(nLoc))  ;
% B = zeros(nLoc*nLag,nLoc*nLag,nTask);
% for t = 1:nTask
%     B(:,:,t) = Xbar(:,:,t)*Xbar(:,:,t)';
% end

fs =[];
CnSum = zeros(Dims);
ZnSum = zeros(Dims);

fval_old = obj_forecasting( Xbar , Y, W, L, Z, ZnSum, CnSum, beta, mu, lambda );
for iter = 1:maxIter
    CnSum = zeros(Dims);
    ZnSum = zeros(Dims);
    for n = 1:nModes
        CnSum = CnSum +  C{n};
        ZnSum = ZnSum + Z{n};
    end
    % Solve W : nLoc X  nLoc*nLag X nTask
    if verbose
        fprintf('Solve W ');
    end
    for t = 1:nTask
%             K  = ( mu*L + eye(nLoc)) \(Y(:,:,t)*Xbar(:,:,t)'+ CnSum(:,:,t)+ beta* ZnSum(:,:,t));
%             W(:,:,t) = sylvester(A ,B(:,:,t), K);
         W(:,:,t) = solveW_GD(Xbar(:,:,t), Y(:,:,t), W(:,:,t),  L, ZnSum(:,:,t), CnSum(:,:,t), beta ,mu ,nModes);

    end
    fval1 = obj_forecasting( Xbar, Y, W, L, Z, ZnSum,  CnSum, beta, mu, lambda);
    % Optimizing over B 
    if verbose
        fprintf('Solve Z\n');
    end
    for n=1:nModes  

        W_n= unfld(W, n);
        if(sum(sum(isnan(W_n)))>0 )
            fprintf('nan value in W');
            keyboard
        end
        Cn_n = unfld(C{n},n);
        Zn_n=shrink(W_n-1/beta*Cn_n, lambda/beta);% BUGGY
        Z{n} = fld2(Zn_n,n, Dims);
    end
    fval2 = obj_forecasting( Xbar, Y, W, L, Z, ZnSum,  CnSum, beta, mu, lambda);
    if verbose
        fprintf('Solve C\n');
    end
     % Optimizing over C  
    for n=1:nModes     
        C{n}=C{n} -  beta*(W-Z{n});
    end
    
    fval = obj_forecasting( Xbar, Y, W, L, Z, ZnSum,  CnSum, beta, mu, lambda);
    if(abs((fval-fval_old)/fval_old) < thres)
        break;
    end
    fval_old = fval;
    fs = [fs,fval];
    if verbose
        fprintf ('ADMM iter %d\n',iter);   
    end
end

end

function val =  obj_forecasting(X, Y, W, L, Z,ZnSum, CnSum, beta, mu, lambda )
val = 0;
nTasks = size(W,3);
nModes = ndims (W);
for t = 1:nTasks
    X_est = W(:,:,t)*X(:,:,t);
    val = val + 0.5*norm(X_est-Y(:,:,t),'fro')^2;    
    val = val  + 0.5* mu* trace(X_est'*L*X_est);
end
tmp = CnSum + beta * ZnSum;

val = val - tmp(:)'*W(:);

val = val + nModes * beta/ 2* norm_fro(W)^2;
for n = 1:nModes
     Zn_n = unfld(Z{n},n);
     S = svd(Zn_n);
     val = val + lambda * sum(S);
end

end


function [W,  fs]= solveW_GD(X, Y, W, L,ZnSum, CnSum, beta , mu ,nModes)
% Uses "Accelerated Gradient Method" to solve the problem.
 maxIter = 1000;
 thres = 7e-5;

 eta = 1e-4;
 fs = inf*zeros(maxIter, 1);
 YW = W;
 t = 1;
 for iter  = 2: maxIter
     [fs(iter), grad] = findGrad(YW, X, Y, mu, L, CnSum, beta, ZnSum, nModes);
      W_new = YW - eta * grad;
      t_new = (1+sqrt(1+4*t^2))/2;
      YW = W_new + ((t-1)/t_new)*(W_new - W);
      W = W_new;
      t = t_new;
      if(abs(fs(iter-1)-fs(iter) )/abs(fs(iter-1))<thres)
          break
      end
      % BUG!
      if(fs(iter-1) < fs(iter))
          break
      end      
 end
 fs = fs*size(W, 1);
fprintf ('Converged after %d iteration\n',iter);
% plot(fs(2:iter));
end

function [obj, grad] = findGrad(W, X, Y, mu, L, CnSum, beta, ZnSum, nModes)
tmp = CnSum + beta*ZnSum;
obj = 0.5* norm(W*X-Y,'fro')^2+ 0.5 *mu* trace ((W*X)'*L*(W*X)) - trace(tmp'*W) + nModes*beta/2 * norm(W,'fro')^2;
grad = ( W*X - Y ) * X' + mu * L *W * (X * X')- (CnSum+beta*ZnSum) + nModes * beta *W;
% This makes tuning eta more robust
obj = obj / size(W, 1);
grad = grad / size(W, 1);
end

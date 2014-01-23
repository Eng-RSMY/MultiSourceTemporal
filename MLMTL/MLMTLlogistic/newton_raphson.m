function [ Wmat, W] = newton_raphson( X, Y, W0, CbetaB, beta ,thres )
%NEWTON_RAPHSON : solve logistic solution for the weights
% X,Y: cell of 1 x numTasks
% X{i} =  featureDim  x numSample
% Y{i} =  1 x numSamples
% W0: starting point, tensor
% CbetaB =  p X number of tasks
% beta constant

% Output: W tensor 
global verbose;

maxIter = 500;

nModes = ndims(W0);
dimModes = size(W0);
nTasks = length(X);
nAttrs = size(CbetaB,1);
Wmat=tenmat(full(W0), 1);
Wmat = Wmat.data;

for t = 1:nTasks
    w_old =Wmat(:,t);
%     Ls =[];
    for iter = 1:maxIter
        p = sigmoid(w_old, X{t});
        df = X{t} * (p-Y{t}) + CbetaB(:,t) + nModes*beta*nModes*eye(nAttrs)*w_old ;
        Sigma = diag(p.*(1-p));
        ddf = X{t}*Sigma*X{t}' + nModes*beta*nModes*eye(nAttrs) ;

        w  = w_old - inv(ddf) * df;

        if( norm(w - w_old,'fro') < thres )
%             if verbose
%                 fprintf('Task %d, converge after %d iteration\n', t, iter);
%             end
            break;
        end

        w_old = w;
%         L = logistic_obj(X{t},Y{t},w, CbetaB(:,t),beta, nModes);
%         Ls =[Ls,L];
    end
    Wmat(:,t) = w;
%     plot(Ls);
end

W=tensor(reshape(Wmat, dimModes));
    
end

   

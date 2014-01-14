function [ W ] = MLMTL_Crosval( X_eval,Y_eval, Func_train, Func_test,lambdas, paras)
%MLMTL_CROSVAL Summary of this function goes here
%   Detailed explanation goes here

global verbose;
numTask = length(X_eval);
N = size(X_eval{1},2);
K = 10; % 10-fold cross validation
dimModes = paras.dimModes;
beta = paras.beta;
outIter = 100;

X_train = X_eval;
Y_train = Y_eval;
X_valid = X_eval;
Y_valid = Y_eval;

avg_err=0;
opt_lambda = -inf;

for lambda = lambdas  
    err =0;
    indices = crossvalind('Kfold',N,K);
    for k = 1:K
        if verbose
            fprintf('lambda: %d, Fold: %d\n',lambda,k);
        end
        validate = (indices ==k); train = ~validate;
        for i = 1:numTask
            X_valid{i} = X_eval{i}(:,validate);
            Y_valid{i} = Y_eval{i}(validate);
            X_train{i} = X_eval{i}(:,train);
            Y_train{i} = Y_eval{i}(train);
        end
        [ W_valid ~ ] = feval(Func_train, X_train, Y_train, dimModes, beta, lambda);
        MSE = feval(Func_test, X_valid,Y_valid, W_valid);
        err  = err + MSE;        
    end
    
     if(err/K < avg_err)
        opt_lambda = lambda;
        avg_err = err/K;
     end
end

if verbose
    fprintf('selected lambda %d\n',opt_lambda);
end

[ W ~ ] = MLMTL_Convex( X_eval, Y_eval, dimModes, beta, opt_lambda );



function [ W ] = MLMTL_Crosval( X_eval,Y_eval, Func_train, Func_test,lambdas, paras)
%MLMTL_CROSVAL Summary of this function goes here
%   Detailed explanation goes here

global verbose;
numTask = length(X_eval);
N = size(X_eval{1},2);
K = 10; % 10-fold cross validation
dimModes = paras.dimModes;
beta = paras.beta;
outIter = paras.outIter;

X_train = X_eval;
Y_train = Y_eval;
X_valid = X_eval;
Y_valid = Y_eval;

avg_err=inf;
opt_lambda = -inf;
errs = [];
for lambda = lambdas  
    err =0;
    indices = crossvalind('Kfold',N,K);
    for k = 1:K

        validate = (indices ==k); train = ~validate;
        for i = 1:numTask
            X_valid{i} = X_eval{i}(:,validate);
            Y_valid{i} = Y_eval{i}(validate);
            X_train{i} = X_eval{i}(:,train);
            Y_train{i} = Y_eval{i}(train);
        end
        [ W_valid ~ ] = feval(Func_train, X_train, Y_train, dimModes, beta, lambda,outIter);
        MSE = feval(Func_test, X_valid,Y_valid, W_valid);
        if verbose
            fprintf('lambda: %d, fold: %d, mse %d \n',lambda,k,mse);
        end
        err  = err + MSE;        
    end
    err = err/K;
    if verbose
        fprintf('lambda: %d, avg_err: %d\n',lambda, err);
    end
    errs = [errs,err];
     if(err < avg_err)
        opt_lambda = lambda;
        avg_err = err;
     end
end

if verbose
    fprintf('selected lambda %d\n',opt_lambda);
%     plot(errs);
end

[ W ~ ] = feval(Func_train, X_train, Y_train, dimModes, beta, lambda, outIter);



function [ W , opt_lambda, train_time] = MLMTL_Crosval( X_eval,Y_eval, Func_train, Func_test,lambdas, paras)
%MLMTL_CROSVAL Summary of this function goes here
%   Detailed explanation goes here

global verbose;

K = 5; % 10-fold cross validation

dimModes = paras.dimModes;
beta = paras.beta;

% outIter = paras.outIter;

errs = [];

nLambda = length(lambdas);

parfor l = 1:nLambda  
    lambda = lambdas(l);
    [avg_err] = Avg_Err(X_eval,Y_eval,Func_train, Func_test, K, lambda,paras);
     errs = [errs,avg_err];
end

[~, idx] = min(errs);
opt_lambda  = lambdas(idx);
if verbose
    fprintf('selected lambda %d\n',opt_lambda);
end
%     plot(errs);

tic;
[ W ~ ] = feval(Func_train, X_eval, Y_eval, dimModes, beta, opt_lambda);
train_time = toc;

end

function [avg_err] = Avg_Err(X_eval,Y_eval,Func_train, Func_test, K,lambda ,paras)
    global verbose;
    dimModes = paras.dimModes;
    beta = paras.beta;
    N = size(X_eval{1},2);
    numTask = length(X_eval);

    indices = crossvalind('Kfold',N,K);
    X_train = X_eval;
    Y_train = Y_eval;
    X_valid = X_eval;
    Y_valid = Y_eval;
    err = 0;
    if verbose
        fprintf('Fold:');
    end
    for k = 1:K
        validate = (indices ==k); train = ~validate;
        for i = 1:numTask
            X_valid{i} = X_eval{i}(:,validate);
            Y_valid{i} = Y_eval{i}(validate);
            X_train{i} = X_eval{i}(:,train);
            Y_train{i} = Y_eval{i}(train);
        end
        [ W_valid ~ ] = feval(Func_train, X_train, Y_train, dimModes, beta, lambda);
        Quality = feval(Func_test, X_valid,Y_valid, W_valid);
        if verbose
            fprintf(' %d',k);
        end
        RMSE = Quality.RMSE;
        err  = err + RMSE;        
    end
    if verbose
        fprintf('\n');
    end

   avg_err = err/K;
end

function [ W, opt_lambda, train_time] = MTGL_Logit_Crosval( X_eval,Y_eval, funcname, lambdas )
% MTGL_Logitics_CROSVAL Summary: cross validation for MTGL
% X: N x D , Y: N x 1
% funcname: Lasso, L21, Dirty
% lambdas range, for choosing 


global verbose;
N = size(X_eval{1},1);
K = 5; % 5-fold cross validation

errs = [];

nLambda = length(lambdas);
   
parfor l = 1:nLambda  
    lambda = lambdas(l);
    [avg_err] = Avg_Err(X_eval,Y_eval,funcname, K, lambda);
     errs = [errs,avg_err];
end
[~, idx] = min(errs);
opt_lambda  = lambdas(idx);
if verbose
    fprintf('selected lambda %d\n',opt_lambda);
end

tic;
[W]  = MTGL_Train(X_eval, Y_eval, funcname, opt_lambda);
train_time = toc;

end

function [avg_err] = Avg_Err(X_eval,Y_eval,funcname, K, lambda)
global verbose
    N = size(X_eval{1},1);
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
            X_valid{i} = X_eval{i}(validate,:);
            Y_valid{i} = Y_eval{i}(validate);
            X_train{i} = X_eval{i}(train,:);
            Y_train{i} = Y_eval{i}(train);
        end
        [W_valid]  = MTGL_Train(X_train, Y_train, funcname, lambda);
        Quality = MTGL_Logit_Test(X_valid, Y_valid, W_valid);
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


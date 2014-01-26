function [ W, opt_lambda, train_time] = MTGL_Crosval( X_eval,Y_eval, funcname, lambdas )
% MTGL_CROSVAL Summary: cross validation for MTGL
% X: N x D , Y: N x 1
% funcname: Lasso, L21, Dirty
% lambdas range, for choosing 


global verbose;
numTask = length(X_eval);
N = size(X_eval{1},1);
K = 5; % 10-fold cross validation


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
        Quality = MTGL_Test(X_valid, Y_valid, W_valid);
        if verbose
            fprintf(' %d',k);
        end
        RMSE = Quality.RMSE;
        err  = err + RMSE;        
    end
    
    err = err/K;
    if verbose
        fprintf('\n lambda: %d, avg_err: %d\n',lambda, err);
    end
    errs = [errs,err];
     if(err < avg_err)
        opt_lambda = lambda;
        avg_err = err;
     end
end

if verbose
    fprintf('selected lambda %d\n',opt_lambda);
end

tic;
[W]  = MTGL_Train(X_eval, Y_eval, funcname, lambda);
train_time = toc;


end


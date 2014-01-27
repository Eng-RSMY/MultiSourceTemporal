function [ W] = MTGL_Train( X, Y ,funcname,lambda )
%MTGL_SELECT Summary: select different multi-task learning algorithms to
%call
%   fucntion:Lasso, L21 or Dirty
% handle of the

if (strcmp(funcname , 'Lasso'))
%     lambda = 1e-3;
    opts.init = 0;      % guess start point from data. 
    opts.tFlag = 1;     % terminate after relative objective value does not changes much.
    opts.tol = 10^-5;   % tolerance. 
    opts.maxIter = 1500; % maximum iteration number of optimization.
    [W funcVal] = Least_Lasso(X, Y, lambda, opts);
    
elseif(strcmp(funcname,'L21'))
%     lambda = 1e-3;
    opts.init = 0;      % guess start point from data. 
    opts.tFlag = 1;     % terminate after relative objective value does not changes much.
    opts.tol = 10^-5;   % tolerance. 
    opts.maxIter = 1000; % maximum iteration number of optimization.

    [W funcVal] = Least_L21(X, Y, lambda, opts);

elseif(strcmp(funcname,'Dirty'))
    opts.init = 0;      % guess start point from data. 
    opts.tFlag = 1;     % terminate after relative objective value does not changes much.
    opts.tol = 10^-4;   % tolerance. 
    opts.maxIter = 500; % maximum iteration number of optimization.

    rho_1 = 350;%   rho1: group sparsity regularization parameter
    rho_2 = lambda;%   rho2: elementwise sparsity regularization parameter
    [W funcVal P Q] = Least_Dirty(X, Y, rho_1, rho_2, opts);
    
    
elseif(strcmp(funcname,'LassoLogit'))
    opts.init = 0;      % guess start point from data. 
    opts.tFlag = 1;     % terminate after relative objective value does not changes much.
    opts.tol = 10^-5;   % tolerance. 
    opts.maxIter = 1500; % maximum iteration number of optimization.
    [W ] = Logistic_Lasso(X, Y, lambda, opts);
    
elseif(strcmp(funcname,'L21Logit'))
%     lambda = 1e-3;
    opts.init = 0;      % guess start point from data. 
    opts.tFlag = 1;     % terminate after relative objective value does not changes much.
    opts.tol = 10^-5;   % tolerance. 
    opts.maxIter = 1000; % maximum iteration number of optimization.

    [W funcVal] = Logistic_L21(X, Y, lambda, opts);
    
    

else
    error('Input error:function name must be Lasso,L21 or Dirty');
end

end


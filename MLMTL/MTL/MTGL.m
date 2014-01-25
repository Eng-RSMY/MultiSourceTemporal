function [ W_tensor ] = MTGL( series, funcname, lambda)
%MTGL : series: 1 X R cell, each cell: P * Times 
%  string
%  funcname: 
% Lasso:'Multi-Task Lasso with Least Squares Loss (Least Lasso)
% L21: 'l2,1-Norm Regularization with Least Squares Loss '
% Dirty: 'A Dirty Model for Multi-Task Learning with the Least Squares Loss

global verbose;
verbose = 1;

nType = length(series);
[nLoc, nTime] = size(series{1});

numTask = nLoc * nType;
dimModes = [nLoc, nLoc,nType]; 

X = cell(numTask,1);
Y = cell(numTask,1);


nSample = nTime-1;
 for type = 1:nType
     % construct feature and label for each task
     for loc = 1:nLoc
         task_idx = (type-1)*nLoc + loc;
         features = zeros(nLoc,nSample);
         labels = zeros(nSample,1);
         
         for sample = 1:nSample
             features(:,sample) = series{type}(:,sample);
             labels(sample) = series{type}(loc,sample+1);
         end
         
         X{task_idx} = features';
         Y{task_idx} = labels;
     end
 end
 
 
 
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

else
    error('Input error:function name must be Lasso,L21 or Dirty');
end

W_tensor=tensor(reshape(W, dimModes));
    
 
end


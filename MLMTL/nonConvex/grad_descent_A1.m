function [xopt,fs,eta] = grad_descent_A1(G_1,A,X,Y,eta_in ,alpha)
% grad_descent.m demonstrates how the gradient descent method can be used
% to solve a simple unconstrained optimization problem. Taking large step
% sizes can lead to algorithm instability. The variable alpha below
% specifies the fixed step size. Increasing alpha above 0.32 results in
% instability of the algorithm. An alternative approach would involve a
% variable step size determined through line search.
%
% This example was used originally for an optimization demonstration in ME
% 149, Engineering System Design Optimization, a graduate course taught at
% Tufts University in the Mechanical Engineering Department. A
% corresponding video is available at:
% 
% http://www.youtube.com/watch?v=cY1YGQQbrpQ
%
% Author: James T. Allison, Assistant Professor, University of Illinois at
% Urbana-Champaign
% Date: 3/4/12
global verbose;

% termination tolerance
tol = 1e-2;

% maximum number of allowed iterations
maxiter = 500;

% minimum allowed perturbation
dxmin = 1e-6;

% step size ( 0.33 causes instability, 0.2 quite accurate)
eta = 1e-4;
if nargin >4
    eta = eta_in;
end
% initialize gradient norm, optimization vector, iteration counter, perturbation
df = inf; x = A{1}; niter = 0; dx = inf;
fs = [];
f = feval(@objc_nonConvex,G_1,[x,A(2:end)],X,Y ,alpha);

% gradient descent algorithm:
while and(df>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
    g = feval(@grad_A1, G_1, [x,A(2:end)], X, Y ,alpha);
    % take step:
    xnew = x - eta*g;
    % check step
    if ~isfinite(xnew)
        display(['Number of iterations: ' num2str(niter)])
        error('x is inf or NaN')
    end

    % update termination metrics
    niter = niter + 1;
    dx = norm(xnew-x);
    fnew = feval(@objc_nonConvex, G_1,[xnew,A(2:end)], X,Y ,alpha);
    if  and(fnew >f,verbose)
        display('Function value increase: shrink step size');
       %         error('step size too big');
        eta = eta/10;
        continue;
    end
    df = abs(fnew - f);
    x = xnew;
    f = fnew;    
    fs =  [fs,f];
    if verbose
        disp(f);
    end
end
if verbose
    display(['A1 converge after ' num2str(niter) ' iterations' ])
end
xopt = x;
end




function [ grad_val ] = grad_A1(G_1, A, X,Y ,alpha)
%GRAD_A1 Summary of this function goes here
%   Detailed explanation goes here
nDims = length(A);
nTasks = length(Y);
nSamples = size(X{1},2);
E = diag(ones(nTasks,1));

outer_prod = A{nDims};
for d = fliplr(2:nDims-1)
    outer_prod = kron(outer_prod,A{d});
end


W_1 =  A{1}*G_1 *outer_prod';

grad_val =0;
for t = 1:nTasks
    L_prime = 2* ( X{t}'*W_1(:,t)- Y{t});% nSample x1
    for i = 1:nSamples
    grad_val = grad_val + L_prime(i)*X{t}(:,i)* outer_prod(t,:)*G_1'; % Can be optimized by looping over K
    end

end
grad_val = grad_val  + 2*alpha *A{1};

end





function [xopt,fs,eta] = grad_descent_An(G_1,A,X,Y,n ,eta_in, alpha)
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
if nargin >5
    eta = eta_in;
end
% initialize gradient norm, optimization vector, iteration counter, perturbation
df = inf; x = A{n}; niter = 0; dx = inf;
fs = [];
f = feval(@objc_nonConvex,G_1,A,X,Y,alpha);

% gradient descent algorithm:
while and(df>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
    A{n} = x;
    g = feval(@grad_An, G_1, A, X, Y,n ,alpha);
    % take step:
    xnew = x - eta*g;
    % check step
    if ~isfinite(xnew)
        display(['Number of iterations: ' num2str(niter)])
        break;
%         error('x is inf or NaN')
    end

    % update termination metrics
    niter = niter + 1;
    dx = norm(xnew-x);
    A{n} = xnew;
    fnew = feval(@objc_nonConvex, G_1,A, X,Y ,alpha);
    if and(fnew >f,verbose)
        display('Function value increase: shrink step size');
        %         error('step size too big');
        eta = eta/10;
        continue
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
    display(['A' num2str(n) 'converge after ' num2str(niter) ' iterations' ])
end
xopt = x;
end


function [ grad_val ] = grad_An(G_1, A, X,Y,n,alpha )
    nDims = length(A);
    nTasks = length(Y);
    nSamples= size(X{1},2);
    
    E = diag(ones(nTasks,1));




    Ps = [];Ks = [];
    for d = 1:nDims
        Ps = [Ps, size(A{d},1)];
        Ks = [Ks, size(A{d},2)];
    end

    
    G = tensor(reshape(G_1,Ks));
    G_n = tenmat(G,n);
    G_n = G_n.data;
    
    Dims_n = setdiff(1:nDims,n);
    outer_prod = A{Dims_n(end)};
    for d = fliplr(Dims_n(1:end-1) )
        outer_prod = kron(outer_prod,A{d});
    end
    
    W_n =  outer_prod* G_n' *A{n}';
    
    

    
    nSlices = nTasks/Ps(n);
    M_theta = nSamples*nSlices;


    grad_val = [];
    X_tilde = zeros(nTasks, M_theta);
    
    for theta = 1:Ps(n)
        theta_idx = [theta:Ps(n):nTasks];           
        % contruct X_tilde
        X_tilde = blkdiag(X{theta_idx});
        Y_tilde = vertcat(Y{theta_idx});
        
        

        L_prime = 2* ( X_tilde'*W_n(:,theta)- Y_tilde);% nSample x1
        grad_val_theta =(G_n* outer_prod'*X_tilde) * L_prime + 2*alpha *A{n}(theta,:)';


        grad_val = vertcat(grad_val, grad_val_theta');
    end

end




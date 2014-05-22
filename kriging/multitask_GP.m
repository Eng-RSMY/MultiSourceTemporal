function [ Ypred ] = multitask_GP( covfunc_x ,xtrain, ytrain , idx_train, xtest, N,M,D) 
%MULTITASK_GP Summary of this function goes here
%   Detailed explanation goes here
% M: nTasks

ntrain = length(idx_train);
nx = ones(ntrain,1);
v = repmat((1:M),N,1); 
ind_kf = v(:);          % indices to tasks
v = repmat((1:N)',1,M);
ind_kx = v(:);          % indices to input space data-points
ind_kx_train = ind_kx(idx_train);
ind_kf_train = ind_kf(idx_train);
% 4. Settings for learning
irank = M;                         % Full rank
nlf = irank*(2*M - irank +1)/2;    % Number of parameters for Lf
theta_lf0 = init_Kf(M,irank);      % Parameter initialization 
theta_kx0 =  init_kx(D);           %
theta_sigma0 = init_sigma(M);      %
logtheta_all0 = [theta_lf0; theta_kx0; theta_sigma0];


% 5. We learn the hyper-parameters here
%    Optimize wrt all parameters except signal variance as full variance
%    is explained by Kf
deriv_range = ([1:nlf,nlf+2:length(logtheta_all0)])'; 
logtheta0 = logtheta_all0(deriv_range);
niter = 1000; % setting for minimize function: number of function evaluations
[logtheta nl] = minimize(logtheta0,'learn_mtgp',niter, logtheta_all0, ...
			 covfunc_x, xtrain, ytrain,...
			 M, irank, nx, ind_kf_train, ind_kx_train, deriv_range);
%
% Update whole vector of parameters with learned ones
logtheta_all0(deriv_range) = logtheta;
theta_kf_learnt = logtheta_all0(1:nlf);
Ltheta_x = eval(feval('covSEard')); % Number of parameters of theta_x
theta_kx_learnt = logtheta_all0(nlf+1 : nlf+Ltheta_x);
theta_sigma_learnt = logtheta_all0(nlf+Ltheta_x+1:end);

% 6. Making predictions at all points on all tasks
Ntest = size(xtest,1);
[alpha, Kf, L, Kxstar] = alpha_mtgp(logtheta_all0, covfunc_x, xtrain, ytrain,...
				    M, irank, nx, ind_kf_train, ...
				    ind_kx_train, xtest);
all_Kxstar = Kxstar(ind_kx_train,:);
for task = 1 : M
  Kf_task = Kf(ind_kf_train,task);
  Ypred(:,task) = (repmat(Kf_task,1,Ntest).*all_Kxstar)'*alpha;
end


return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta_kx0 = init_kx(D)
theta_kx0 = [log(1); log(rand(D,1))];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta_lf0 = init_Kf(M,irank)
Kf0 = eye(M);                 % Init to diagonal matrix (No task correlations)
Lf0 = chol(Kf0)';
theta_lf0 = lowtri2vec_inchol(Lf0,M,irank);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta_sigma0 = init_sigma(M)
theta_sigma0 =  (1e-7)*rand(M,1);  



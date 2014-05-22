function toy_example()
% function toy_example()
% A toy example demonstrating how to use the mtgp package  for M=2 tasks 
% 1. Generates sample from true MTGP model 
% 2. Selects data-points for training
% 3. Plots training data
% 4. Sets parameters for learning (including initialization) 
% 5. Learns hyperparameters with minimize function
% 6. Makes predictions at all points on all tasks
% 7. Plots the predictions

rand('state',18);
randn('state',20);
M = 2;    % Number of tasks
D = 2;    % Dimensionality of input space. try D=1 and D=2
covfunc_x = 'covSEard'; % Covariance function on input space

if (D==1)
  x = linspace(-1,1)'; % Alternative
elseif (D==2)
  [X1,X2] = meshgrid(-1:.2:1, -1:.2:1);
  x = [X1(:), X2(:)];
end

[N D]= size(x); % Total number of samples per task
n = N*M;        % Total number of samples

% 1. Generating samples from true Model
[y, ind_kf, ind_kx] = generate_true_samples(x, covfunc_x, N, D, M);
Y = reshape(y,N,M);

% 2. Selecting data-points for training
ntrain = floor(0.1*n);
v = randperm(n); 
idx_train = v(1:ntrain);
nx = ones(ntrain,1); % Number of observations on each task-input point
ytrain = y(idx_train);
xtrain = x; 
ind_kx_train = ind_kx(idx_train);
ind_kf_train = ind_kf(idx_train);

% 3. Plotting all data and training data here
if (D==1)
  plot(x,Y,'ko','markersize',5);
elseif (D==2)
  plot3(x(:,1),x(:,2),Y,'ko','markersize',7);
end
hold on;
for j = 1 : M 
  idx = find(ind_kf_train == j);
  if (D==1)
    plot(x(ind_kx_train(idx),:),Y(ind_kx_train(idx),j),'k.','markersize',10);
  elseif (D==2)
    plot3(x(ind_kx_train(idx),1),x(ind_kx_train(idx),2),...
	  Y(ind_kx_train(idx),j),'k.','markersize',18);
  end
  hold on;
end

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
xtest = x;
Ntest = size(xtest,1);
[alpha, Kf, L, Kxstar] = alpha_mtgp(logtheta_all0, covfunc_x, xtrain, ytrain,...
				    M, irank, nx, ind_kf_train, ...
				    ind_kx_train, xtest);
all_Kxstar = Kxstar(ind_kx_train,:);
for task = 1 : M
  Kf_task = Kf(ind_kf_train,task);
  Ypred(:,task) = (repmat(Kf_task,1,Ntest).*all_Kxstar)'*alpha;
end

% 7. Plotting the predictions
hold on;
if (D==1)
  plot(x,Ypred); % 
  elseif (D==2)
    for j = 1 : M % visualizing
      surf(X1,X2,reshape(Ypred(:,j),size(X1,1),size(X1,2))); 
      hold on;
    end
end
grid on;
figure, plot(nl); title('Negative Marginal log-likelihood');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y, ind_kf, ind_kx] = generate_true_samples(x,covfunc_x,N,D,M)
n = N*M;
Kf = [1.0 0.9 ; ...
      0.9 1.0];
Lf = chol(Kf)';
theta_x = [log(1);              % Signal variance
	   log(ones(D,1))];        % Length-scales
theta_sigma = log(sqrt(0.0001*ones(M,1))); % Noise variances
Sigma2 = diag(exp(2*theta_sigma));
Kx = feval(covfunc_x,theta_x,x);
C = kron(Kf,Kx) + kron(Sigma2,eye(N));
L = chol(C)';    
y = L*randn(n,1);       % Noisy observations
v = repmat((1:M),N,1); 
ind_kf = v(:);          % indices to tasks
v = repmat((1:N)',1,M);
ind_kx = v(:);          % indices to input space data-points
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta_kx0 = init_kx(D)
theta_kx0 = [log(1); log(rand(D,1))];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta_lf0 = init_Kf(M,irank)
Kf0 = eye(M);                 % Init to diagonal matrix (No task correlations)
Lf0 = chol(Kf0)';
theta_lf0 = lowtri2vec_inchol(Lf0,M,irank);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function theta_sigma0 = init_sigma(M);
theta_sigma0 =  (1e-7)*rand(M,1);  
 


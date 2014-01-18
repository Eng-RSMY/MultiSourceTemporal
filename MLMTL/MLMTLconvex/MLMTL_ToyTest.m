global verbose ;
verbose =0;


folds = [10,10];
nTasks = prod(folds);
X = cell(1, nTasks);
Y = cell(1, nTasks);

nDim = 50;
r_convex =[];
r_mixture =[];
r_greedy = [];
nSample = 20; 
W = zeros(nDim, nTasks);

loop_var = [50:20:200];
for nSample = loop_var
for i = 1:nTasks
    X{i}=rand(nDim,nSample);
    W(:,i) = rand(1,nDim);
    Y{i}=X{i}'*W(:,i);
end
    
dimModes = [nDim,folds];
beta = 1e-2;
lambda = 1e-3;
% outerNiTPre = 50;

mu = 1e-5;
max_iter = 5; %% need to change the stop criteria as convergence


threshold = 1e-5;

% lambdas = logspace(-3,3,10);% lambda is quite small , 10-3 

% paras.beta = beta;
% paras.dimModes = dimModes;

% W_Convex = MLMTL_Crosval(X,Y,@MLMTL_Convex,@MLMTL_Test,lambdas, paras);
% W_Mixture = MLMTL_Crosval(X,Y,@MLMTL_Mixture,@MLMTL_Test,lambdas, paras);
%
tic;
[ W_r_convex tensorW_r_convex Ls_Convex ] = MLMTL_Convex( X, Y, dimModes, beta, lambda);
toc;
% 
% for innerNiTPre = loop_var
[ W_r_mixture tensorW_r_mixture Ls_Mixture] = MLMTL_Mixture( X, Y, dimModes, beta, lambda);
toc;
[ W_r_greedy, qualityGreedy, errGreedy] = solveGreedyOrth(Y, X, mu, max_iter, threshold);
toc;

end
%% evaluate
e_convex = norm(W_r_convex- W,'fro')/(nDim*nTasks);
e_mixture = norm(W_r_mixture- W,'fro')/(nDim*nTasks);
e_greedy = norm (squeeze(W_r_greedy) -W, 'fro')/(nDim*nTasks);

fprintf('frobenius norm error Convex: %d Mixture: %d Greedy: %d \n ',e_convex,e_mixture, e_greedy);

r_convex = [r_convex,e_convex];
r_mixture = [r_mixture, e_mixture];
r_greedy = [r_greedy,e_greedy];




%% plot
% plot(Ls_Convex,'b'); hold on;
% plot(Ls_Mixture,'r'); hold off;
plot(loop_var,r_convex.*1/(nDim*nTasks),'b'); hold on;
plot(loop_var,r_mixture.*1/(nDim*nTasks),'r'); hold on;
plot(loop_var,r_greedy.*1/(nDim*nTasks),'k'); hold off;

% 
% 
% xlabel('Coordinate Descent Iter');
% ylabel('Frobenius Norm Error');
% legend('Overlap Method [Romera-ParedesICML13]','Latent Method');
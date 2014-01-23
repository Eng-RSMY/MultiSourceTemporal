% Synthetic 
global verbose ;
verbose =0;

clear;
folds = [3,3];
nTasks = prod(folds);
X = cell(1, nTasks);
Y = cell(1, nTasks);

nDim = 5;
Rank = 3;
r_convex =[];
r_mixture =[];
r_greedy = [];
r_lasso = [];
nSample = 20; 
W = zeros(nDim, nTasks);

loop_var = 20:20:300;
r_convex = [];
r_nuclear = [];

dimModes = [nDim,folds];
beta = 1e-2;
lambda = 1e-8;

mu = 1e-5;
max_iter = 20; %% need to change the stop criteria as convergence


threshold = 1e-5;

for nSample = loop_var    
    
    for i = 1:nTasks
        X_i=rand(nDim,nSample);
        %     [U,S,V] = svd(X_i);
        %     X_i = U(:,1:Rank)*S(1:Rank,1:Rank)*V(:,1:Rank)';
        X{i} = X_i;
        W(:,i) = rand(1,nDim);
        Y{i}=X{i}'*W(:,i);
    end


    % lambdas = logspace(-3,3,10);% lambda is quite small , 10-3 

    % paras.beta = beta;
    % paras.dimModes = dimModes;

    % W_Convex = MLMTL_Crosval(X,Y,@MLMTL_Convex,@MLMTL_Test,lambdas, paras);
    % W_Mixture = MLMTL_Crosval(X,Y,@MLMTL_Mixture,@MLMTL_Test,lambdas, paras);
    

    tic;
    [ W_r_nuclear tensorW_r_nuclear Ls_nuclear ] = MLMTL_Convex( X, Y, [nDim,nTasks], beta, lambda);
    toc;

    [ W_r_convex tensorW_r_convex Ls_Convex ] = MLMTL_Convex( X, Y, [nDim,folds], beta, lambda);
    toc;
    
    [ W_r_mixture tensorW_r_mixture Ls_Mixture] = MLMTL_Mixture( X, Y, [nDim,folds], beta, lambda);
    toc;
    
    
    [ W_r_lasso tensorW_r ] = ML_Lasso(X, Y, [nDim,folds]);
    toc;

    % [ W_r_greedy, qualityGreedy, errGreedy] = solveGreedyOrth(Y, X, mu, max_iter, threshold);
    % toc;


    %% evaluate
    e_nuclear = norm(W_r_nuclear- W,'fro')/(nDim*nTasks);
    e_convex = norm(W_r_convex- W,'fro')/(nDim*nTasks);
    e_mixture = norm(W_r_mixture- W,'fro')/(nDim*nTasks);
    e_lasso = norm(W_r_lasso- W,'fro')/(nDim*nTasks);

%   fprintf('frobenius norm error Nuclear: %d  Convex: %d Mixture: %d   \n ',e_nuclear, e_convex , e_mixture);

    r_nuclear = [r_nuclear, e_nuclear];
    r_convex = [r_convex,e_convex];
    r_mixture = [r_mixture, e_mixture];
    r_lasso = [r_lasso, e_lasso];


end


%% plot
% plot(Ls_Convex,'b'); hold on;
% plot(Ls_Mixture,'r'); hold off;
% plot(loop_var,[r_convex', r_nuclear', r_mixture']); hold on;

plot(loop_var,[r_convex', r_nuclear', r_mixture',r_lasso']); 

% legend('Convex','Nuclear','Mixture');

% xlabel('Coordinate Descent Iter');
% ylabel('Frobenius Norm Error');
% legend('Overlap Method [Romera-ParedesICML13]','Latent Method');

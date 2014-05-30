% 
% nLoc = 4;
% nTime = 10;
% nTask = 5;
% X = rand(nLoc,nTime, nTask);
% A = rand(nLoc, nLoc);
% Sim = A'*A;



lambda = 1e-5;
beta = 1;
mu = 1;
sigma = 1;
nLag = 3;
% [ W fs] = convex_forecasting( X,  Sim, lambda, beta, mu, nLag );
%%
% plot(fs)

%%
load 'climateP17.mat'

nTask = length(series);
[nLoc nTime] = size(series{1});

X = zeros([nLoc, nTime, nTask]);

for t = 1:nTask
    X(:,:,t) = series{t};
end
Sim = sim_Gaussian(locations, sigma);
Sim = Sim/max(Sim(:));
nLag = 3;
[W fs ] =  convex_forecasting( X(:,1:124,:),  Sim, lambda, beta, mu, nLag );

%% 
nTest = 31;
Xbar = zeros(nLoc*nLag, nTest, nTask);
Y_est = zeros(nLoc, nTest, nTask);

for t = 1:nTask
    for l = 1:nLag
        Xbar((l-1)*nLoc+1:l*nLoc,: ,t) = X(:,125-l:125+nTest-l,t);       
    end
    Y(:,:,t) = X(:,125:nTime,t);
    Y_est (:,:,t) = W(:,:,t) * Xbar (:,:,t);
end


RMSE  = sqrt ( norm_fro(Y_est- Y )^2 / numel (Y ) );

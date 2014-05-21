nTasks = 3;
nSamples = 10;
nLocs= 5;
beta = 0.5;
X = cell(nTasks, 1);
for t = 1: nTasks
    X{t} = rand([nLocs,nSamples]);
end
Dims = [nLocs,nLocs ,nTasks];
[W fs] = para_kriging(X, beta, Dims);
%%
clear; clc; genData_ClimateP3;
beta = 1e-2; lambda = 1e-3;
nTasks = length(series_partial);
[nLocs nSamples] = size(series_partial{1});
Dims = [nLocs, nLocs, nTasks];
[W fs] = para_kriging(series_partial, beta,lambda, Dims);

%% 
Sigma = zeros(Dims);
task = 3;
for t= 1:nTasks
    Sigma (:,:,t) = inv(W(:,:,t) * W(:,:,t)');
end


D = squareform(pdist(names(observe_idx,2:end), 'euclidean'));
dist = D( observe_idx(1),:);

cov_est  = Sigma(observe_idx(1),:,task);

scatter(dist, cov_est);xlabel('distance'); ylabel('covariance');

%% empirical covariance

Sigma_emp = cov(series_partial{task}');
cov_emp = Sigma_emp(observe_idx(1),:);

scatter(dist, cov_emp); xlabel('distance'); ylabel('covariance');


%% make prediction
D = squareform(pdist(names(:,2:end), 'euclidean'));
D_observe = D(observe_idx,observe_idx);
for t = 1:1%nTasks
for i = 1:1%length(observe_idx)
    x = D_observe(:,i);
    y = Sigma(:,i,t);
    f = fit(x,y,'exp1');
    plot(f,x,y , 'markersize', 10);
end
    
end
    




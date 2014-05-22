nTasks = 3;
nSamples = 10;
nObserve= 5;
beta = 0.5;
X = cell(nTasks, 1);
for t = 1: nTasks
    X{t} = rand([nObserve,nSamples]);
end
Dims = [nObserve,nObserve ,nTasks];
[W fs] = para_kriging(X, beta, Dims);
%%
clear; clc; genData_ClimateP3;
beta = 1e-2; lambda = 1e-3;
nTasks = length(series_partial);
[nObserve nSamples] = size(series_partial{1});
Dims = [nObserve, nObserve, nTasks];
[W fs] = para_kriging(series_partial, beta,lambda, Dims);


Sigma = zeros(Dims);
Omega = zeros(Dims);
task = 3;
for t= 1:nTasks
    Omega (:,:,t) = W(:,:,t) * W(:,:,t)';
    Sigma (:,:,t) = inv(W(:,:,t) * W(:,:,t)');
end

%%

D = squareform(pdist(names(observe_idx,2:end), 'euclidean'));
dist = D( observe_idx(1),:);

cov_est  = Sigma(observe_idx(2),:,task);

scatter(dist, cov_est);xlabel('distance'); ylabel('covariance');

%% empirical covariance
for t= 1:nTasks
    Sigma_emp (:,:,t) = cov(series_partial{task}');
end
cov_emp = Sigma_emp(observe_idx(1),:,t);

scatter(dist, cov_emp); xlabel('distance'); ylabel('covariance');


%% fit to estimate covariance
Sigma = Sigma;
D = squareform(pdist(names(:,2:end), 'euclidean'));
D_observe = D(observe_idx,observe_idx);
cov_fit = zeros(nObserve , nMissing , nTasks);
for t = 1:nTasks
for i = 1:nObserve
    x = D_observe(:,i);
    y = Sigma(:,i,t);
    f_fit = fit(x(1:end),y(1:end),'exp1');
%     plot(f,x,y , 'markersize', 10);

    % get the distance and fit the variance
    
    cov_fit(i,:,t) = f_fit.a* exp(f_fit.b*D(observe_idx(i),missing_idx));    
end
    
end

%% make estimation

for t  = 1:nTasks
    for  time = 1:nTime
        kriging_est{t}(:,time)  = cov_fit(:,:,t)'*inv(Sigma(:,:,t))* series_partial{t}(:,time);
        
    end
end
%% evaluate performance
err_RMSE = zeros(nTasks,1);

for t = 1:nTasks
    err_RMSE(t) = sqrt(norm(kriging_est{t} - series{t}(missing_idx,:),'fro')^2/(nTime*nMissing));
end

    




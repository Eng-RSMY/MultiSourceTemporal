% prepare data
seed=22;

dx = 4;
dy = 4; % dim of tasks
dimMode = [dx, sqrt(dy),sqrt(dy)];
n = 10;
r = 2;
noise_std = .5;
beta = 1e-2;
% generate random Gaussians and W0
Sigma_xxG = randn(dx,dx);
Sigma_yyG = randn(dy,dy);
Sigma_xx = Sigma_xxG' * Sigma_xxG;
Sigma_yy = Sigma_yyG' * Sigma_yyG;
Sigma_mm = kron( Sigma_yy, Sigma_xx);
W0 = randn(dx,dy);
[U,S,V] = svd(W0);
S(r+1:end,r+1:end) = 0;
W0 = U * S * V'; % the low rank matrix
U0 = U(:,1:r); U0orth = U(:,r+1:end);
V0 = V(:,1:r); V0orth = V(:,r+1:end);

Z = cell(1,dy);
M = cell(1,dy);
noise = rand(n,1) * noise_std;
for i = 1:dy
    M{i} = rand(dx,n);
    Z{i} = M{i}' * W0(:,i) + noise;
end
lambdamin = 5.88e-7;
lambdamax = 348;
nlambdas  = 200;
lambdas  = logspace(lambdamin, lambdamax, nlambdas);
svds = [];

fprintf('Trying %d values of lambdas\n',length(lambdas));
for ilambda = 1:length(lambdas)
    lambda = lambdas(ilambda);
    fprintf('%d - lambda = %1.2e\n', ilambda, lambda);
    [ W tensorW ] = MLMTL_Mixture( M, Z, dimMode, beta, lambda );

    svds(:,ilambda) = svd(W);
    dists(ilambda) = norm(W-W0,'fro')^2;

end


plot(-log(lambdas),svds','linewidth',2); hold on;
plot(-log(lambdas),repmat(svd(W0),1,length(lambdas))',':','linewidth',2); hold off
axis( [ min(-log(lambdas) ) max(-log(lambdas) ) 0 max(svds(:))*1.1] );
xlabel('-log(\lambda)','fontsize',16);
ylabel('singular values','fontsize',16);
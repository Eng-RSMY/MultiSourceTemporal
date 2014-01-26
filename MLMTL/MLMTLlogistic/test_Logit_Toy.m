global verbose;
verbose = 1;
nTasks = 6;
X = cell(1,nTasks);
Y = cell(1,nTasks);
N = 20;
P = 3;
dimModes = [P,3,2];
nModes = 3;
matSumAux = rand(P,nTasks);
beta = 1e-2;
thres = 1e-3;

for t = 1:nTasks
    X{t} = rand(P,N);
    W(:,t) = rand(P,1);

    Y{t} = double(sigmoid(W(:,t),X{t}) >0.5);
end

W0 =tenzeros(dimModes);
[W_r, ~] = newton_raphson(X,Y, W0, matSumAux, beta,thres);

%%
[ L ] = logistic_obj(X{1},Y{1},W(:,1), matSumAux(:,1),beta, nModes);

%%
[ prec ] = MLMTL_Test_Logit(X, Y, W );
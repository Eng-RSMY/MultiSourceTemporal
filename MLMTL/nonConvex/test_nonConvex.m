Ks = [2,3,5];
Ps = [3,5,10];
alpha = 0.5;
nDims = length(Ps);
nTasks = prod(Ps(2:end));
X = cell(1,nTasks);
Y = cell(1,nTasks);
A = cell(1,nDims);

nFeatures = Ps(1);
nSamples = 20;
maxIter = 8;

W_1 = rand(Ps(1), nTasks);
for t = 1:nTasks
    X{t}= rand(nFeatures, nSamples);
    
    Y{t}= X{t}'*W_1(:,t);
end

for d = 1:nDims
    A{d} = rand(Ps(d),Ks(d));
end

G = tensor(-1*rand(Ks(1),Ks(2),Ks(3)));
G_1=tenmat(full(G), 1);
G_1=G_1.data;
f_A = cell(nDims, 1);
etaG =  1e-6;
etaA1 = 1e-3;
etaA2 = 1e-4;
etaA3 = 1e-4;

for iter = 1:maxIter

    % minimize over G

    [G_1, f_G_1 ,etaG] = grad_descent_G(G_1, A, X, Y,etaG, alpha);
    etaG = etaG /10;

    % minimize over A1
    [A{1}, f_A{1}, etaA1] = grad_descent_A1(G_1, A, X, Y,etaA1, alpha);
    etaA1 = etaA1 /10;
    % minimize over An

    [A{2},f_An, etaA2] = grad_descent_An(G_1,A,X,Y,2 , etaA2,alpha);
    f_A{2} = f_An;
    etaA2 = etaA2/10;
    
    [A{3},f_An ,etaA3] = grad_descent_An(G_1,A,X,Y,3 , etaA3, alpha);
    f_A{3} = f_An;
    etaA3 = etaA3/10;
    disp(iter );
end

%%
outer_prod = A{nDims};
for d = fliplr(2:nDims-1)
    outer_prod = kron(outer_prod,A{d});
end
W  = A{1}*G_1 *outer_prod';
Ks = [2,3,5];
Ps = [3,5,10];
nDims = length(Ps);
nTasks = prod(Ps(2:end));
X = cell(1,nTasks);
Y = cell(1,nTasks);
A = cell(1,nDims);

nFeatures = Ps(1);
nSamples = 20;

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

[G_1 f_G_1] = grad_descent_G(G_1, A, X, Y,1e-3);
plot(f_G_1);


% [A1 f_A1] = grad_descent_A1(G_1, A, X, Y);
% plot(f_A1);

% [A2,f_A2] = grad_descent_An(G_1,A,X,Y,2);
% 
% plot(f_A2);
% % 
% [A3,f_A3] = grad_descent_An(G_1,A,X,Y,3 ,1e-5);
% 
% plot(f_A3);
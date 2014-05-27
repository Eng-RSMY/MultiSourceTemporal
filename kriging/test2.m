function test2
clc
% The test works for a single vector

L = randn(10, 10);
L = L*L';

Iomega = [zeros(2), zeros(2, 8); zeros(8, 2), eye(8)];

D = randn(10, 20);

X = randn(10, 20);

obj1 = objective1(L, X, D, Iomega);
obj2 = objective2(L, X, D, Iomega);

disp(obj1)
disp(obj2)

end

function obj = objective1(L, X, D, Iomega)
obj = norm( Iomega*(X-D), 'fro' )^2 + trace(X'*L*X);
end

function obj = objective2(L, X, D, Iomega)
Q = chol(Iomega + L);
M = (Q')\(Iomega*D);
obj = norm(Q*X - M, 'fro')^2 + trace(D'*Iomega*D) - norm(M, 'fro')^2;
end
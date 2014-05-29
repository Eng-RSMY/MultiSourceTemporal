function test2
clc
% The test works for a single vector

p = 100;
q = 200;
T = 1000;

L = randn(p, p);
L = L*L';

X = randn(p, T);
W = randn(p, q);
Y = randn(q, T);

obj1 = objective1(L, X, Y, W);
obj2 = objective2(L, X, Y, W);

delta = 1e-6;
i = 2; j = 3;
W(i, j) = W(i, j) + delta;
obj1p = objective1(L, X, Y, W);
obj2p = objective2(L, X, Y, W);

disp((obj1p - obj1)/delta)
disp((obj2p - obj2)/delta)

end

function obj = objective1(L, X, Y, W)
obj = norm( W*Y-X, 'fro' )^2 + trace(Y'*W'*L*W*Y);
obj = obj/numel(X);
end

function obj = objective2(L, X, Y, W)
U = chol(eye(size(L)) + L);
B = (U')\X;
obj = norm(U*W*Y - B, 'fro')^2;
obj = obj/numel(X);
end
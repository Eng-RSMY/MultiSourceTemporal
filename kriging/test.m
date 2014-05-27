function test
% The test works for a single vector

L = randn(10, 10);
L = L*L';

X = randn(10, 20);

[obj, G] = findGrad(L, X);

i = 2;
j = 4;
delta = 1e-8;
X(i, j) = X(i, j) + delta;
obj2 = findGrad(L, X);

disp(G(i, j))
disp((obj2-obj)/delta)

end

function [obj, G] = findGrad(L, X)
obj = trace(X'*L*X);
G = 2*L*X;
end
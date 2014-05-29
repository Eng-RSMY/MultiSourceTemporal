function test
% The test works for a single vector

L = randn(10, 10);
L = L*L';

W = randn(10, 20);
X = randn(20, 10);

[obj, G] = findGrad(L, W, X);

i = 2;
j = 4;
delta = 1e-8;
W(i, j) = W(i, j) + delta;
obj2 = findGrad(L, W, X);

disp(G(i, j))
disp((obj2-obj)/delta)

end

function [obj, G] = findGrad(L, W, X)
obj = trace(X'*W'*L*W*X);
G = 2*L*W*X*X';
end
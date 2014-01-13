% Test Solve Greedy
clc
clear 

global verbose
verbose = 1;

p = 20;
q = 10;
r = 3;
n = 100;

X = cell(r, 1);
Y = cell(r, 1);

for i = 1:r
    X{i} = randn(p, n);
    A = randn(q, 2)*randn(2, p);
    Y{i} = A*X{i} + 0.1 * randn(q, n);
end

mu = 1e-2;
max_iter = 50;
solveGreedyOrth(Y, X, mu, max_iter);
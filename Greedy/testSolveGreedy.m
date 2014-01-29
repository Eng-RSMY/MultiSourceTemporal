% Test Solve Greedy
clc
% clear 

addpath('./GreedySubFunc/')

global verbose
verbose = 0;

global evaluate
evaluate = 0;

p = 20;
q = 10;
r = 10;
n = 1000;
sig = 0.3;

X = cell(r, 1);
Y = cell(r, 1);

test.X = cell(r, 1);
test.Y = cell(r, 1);
A = randn(q, 2)*randn(2, p);
for i = 1:r
    X{i} = randn(p, n);
    Y{i} = A*X{i} + sig * randn(q, n);
    test.X{i} = randn(p, n);
    test.Y{i} = A*test.X{i} + sig * randn(q, n);
end

% load goodGreedySynth2.mat

mu = 2e-8;
max_iter = 50;
% solveGreedyOrth(Y, X, mu, max_iter, A, test);

profile on
solveGreedy(Y, X, mu, max_iter, A, test);
profile off
profile viewer
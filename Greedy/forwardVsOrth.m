% Test Solve Greedy
clc
clear 

addpath('./GreedySubFunc/')

global verbose
verbose = 0;

global evaluate
evaluate = 1;

p = 20;
q = 10;
r = 3;
n = 1000;
A = randn(q, 2)*randn(2, p);
mu = 2e-8;
max_iter = 20;

X = cell(r, 1);
Y = cell(r, 1);
test.X = cell(r, 1);
test.Y = cell(r, 1);
for i = 1:r
    X{i} = randn(p, n);
    test.X{i} = randn(p, n);
end

sig = logspace(-3, 0, 6);
qSolOrth = cell(length(sig), 1);
qSolFor = cell(length(sig), 1);
for j = 1:length(sig)
    for i = 1:r
        Y{i} = A*X{i} + sig(j) * randn(q, n);
        test.Y{i} = A*test.X{i} + sig(j) * randn(q, n);
    end
    [~, qSolOrth{j}] = solveGreedyOrth(Y, X, mu, max_iter, A, test);
    [~, qSolFor{j}] = solveGreedy(Y, X, mu, max_iter, A, test);
    disp(j)
end
save('greedyForOrth.mat', 'qSolFor', 'qSolOrth', 'max_iter', 'sig')
%% Plotting
load('greedyForOrth.mat')
ind = (1:max_iter)';
for i = 1:6
    figure
    hold all
    for j = 1:length(sig)
        plot(ind, qSolFor{j}(:, i), '-o')
        plot(ind, qSolOrth{j}(:, i), '-^')
    end
end
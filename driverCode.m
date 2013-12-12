clear all
clc
close all

addpath('./algos/')

load synth.mat

global verbose
verbose = 0;
addpath('../../Hidden/Experiments/comP/func')
method = 'poissonHidden'; 
L = 5;
[N T] = size(count);
Lambda_S = logspace(-7, -3, 11);
%% Cross-Validation
nCV = 5;
index = cell(nCV, 1);
ind = L + randperm(T-L);
step = T/nCV;
for i = 1:nCV-1
    index{i} = ind((i-1)*step+1:i*step);
end
index{nCV} = ind((nCV-1)*step+1:end);
errL = zeros(size(Lambda_S));
for j = 1:length(Lambda_S)
    normerr = zeros(nCV, 1);
    lambda = Lambda_S(j);
    parfor i = 1:nCV
        [~, normerr(i)] = feval(method, count, lambda, index, i, S, 5);
    end
    fprintf('Iteration: %d\n', j)
    errL(j) = sum(normerr);
end
[~, ix] = min(errL);
Lambda_1 = Lambda_S(ix(end));
disp(Lambda_1)
%% Final Evaluation
verbose = 1;
i = 2;
index{1} = L+1:T-1;
index{2} = T;
[~, ~, ~, ~, AUC] = feval(method, count, Lambda_1, index, i, S, 5);
disp(AUC)

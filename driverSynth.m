clear all
clc
close all

addpath(genpath('../MultiSourceTemporal'))

series = cell(3, 1);
load synthGumbel.mat
series = series - mean(series, 2)*ones(1, size(series, 2));
series = series./(std(series, 0, 2)*ones(1, size(series, 2)))* (pi)/sqrt(6);

global verbose
verbose = 1;

TLam = 100;
lambda = [10, 1e-6];
nLag = 1;
T = size(series, 2);
Ttest = 200;
index{1} = nLag+1:T-Ttest;
index{2} = T-Ttest+1:T;

grad = {@gradGaussian, 'Gaussian'};
% grad = {@gradGumbel, 'Gumbel'};
[S, err, normerr] = sparseGLARP(series, lambda(2), nLag, index, grad);
disp(norm(S{1} - A, 'fro')/norm(A, 'fro'))
disp(err);
disp(normerr);
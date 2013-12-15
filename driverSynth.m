clear all
clc
close all

addpath(genpath('../MultiSourceTemporal'))

series = cell(3, 1);
load synthGauss.mat


global verbose
verbose = 1;

TLam = 100;
lambda = [10, 1e-5];
nLag = 1;
T = size(series, 2);
Ttest = 100;
index{1} = nLag+1:T-Ttest;
index{2} = T-Ttest+1:T;

grad = {@gradGaussian, 'Gaussian'};
% grad = {@gradGumbel, 'Gumbel'};
[S, err, normerr] = sparseGLARP(series, lambda(2), nLag, index, grad);
disp(norm(S{1} - A, 'fro')/norm(A, 'fro'))
disp(err)
disp(normerr)
clear all
clc
close all

addpath(genpath('./'))

series = cell(3, 1);
load temp.mat
series{1} = obs';
load wind.mat
series{2} = obs';
load rain.mat
series{3} = (obs > 0.01)'*1.0;
clear obs pars  % Housekeeping


global verbose
verbose = 1;

TLam = 100;
lambda = [0.01, 1e-4];
nLag = 3;
T = size(series{1}, 2);
Ttest = 10;
index{1} = nLag+1:T-Ttest;
index{2} = T-Ttest+1:T;
[Sol, err, normerr] = coreg(series, TLam, lambda, nLag, index);
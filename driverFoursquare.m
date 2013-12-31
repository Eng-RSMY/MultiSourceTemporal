clear;
clc;
addpath('./data/Foursquare/')
global verbose
verbose = 1;


%%
load 'venue_checkin_daily.mat';
series = venue_checkin_counts(1:100,:);

TLam = 100;
lambda = [1, 1e-5];
nLag = 5;
T = size(series, 2);
Ttest = 10;
index{1} = nLag+1:T-Ttest;
index{2} = T-Ttest+1:T;
Lambda_2 = lambda(2);
%%
grad = {@gradPoisson, 'Poisson'};
[Sol, err, normerr] = sparseGLARP(series, Lambda_2, nLag, index, grad);


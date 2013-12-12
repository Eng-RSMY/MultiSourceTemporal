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
lambda = 0.01;
nLag = 3;
Sol = coreg(series, TLam, lambda, nLag);


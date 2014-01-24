% The goal of this script is to run several instances of 'runSynthOne' and
% aggregate the results
clc
clear

global verbose
verbose = 0;

addpath(genpath('./Greedy/'))
addpath(genpath('./MLMTL/'))
addpath('./TTI/nway331/')

[qReg, qGreed] = runSynthOne(100);
% The goal of this script is to run several instances of 'runSynthOne' and
% aggregate the results
clc
clear

global verbose
verbose = 0;

addpath(genpath('./Greedy/'))
addpath(genpath('./MLMTL/'))
addpath('./TTI/nway331/')

% Greedy Quality: [obj, ERMSE, LRCp, TKCp, PRMSE, NPRMSE, time]
% REgularized Quality: [errReg, rankReg, trcompReg, predReg, time]

tlen = floor(logspace(1, 3, 8));

qGreed = zeros(length(tlen), 6);
qReg = zeros(length(tlen), 5);
parfor i = 1:length(tlen)
    [qReg(:, i), qGreed(:, i)] = runSynthOne(tlen(i));
end
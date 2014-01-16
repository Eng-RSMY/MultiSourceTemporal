% Comparing the speed of two algorithms
clc
clear

addpath(genpath('../MLMTL/'))

load('../data/climateP17.mat')
% load synth_r10.mat
nLag = 2;
nTask = length(series);
[nLoc, tLen] = size(series{1});

%% Run MLMTL
X = cell(nTask*nLoc, 1);
Y = X;
for i = 1:nTask
    for j = 1:nLoc
        Y{j+(i-1)*nLoc} = series{i}(j, nLag+1:tLen)';
        X{j+(i-1)*nLoc} = zeros(nLag*nLoc, (tLen - nLag));
        for ll = 1:nLag
            X{j+(i-1)*nLoc}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, nLag+1-ll:tLen-ll);
        end
    end
end
indicators = [nLoc*nLag, nTask, nLoc];
lambda = 1e-5;
beta = 2e-2;

tic
MLMTL_Mixture( X, Y, indicators, beta, lambda, 100);
timeMLMTL = toc;

%% Run Greedy
global verbose
verbose = 0;
X = cell(nTask, 1);
Y = cell(nTask, 1);
for i = 1:nTask
    Y{i} = series{i}(:, nLag+1:tLen);
    X{i} = zeros(nLag*nLoc, (tLen - nLag));
    for ll = 1:nLag
        X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, nLag+1-ll:tLen-ll);
    end
end

tic
mu = 1e-4;
max_iter = 10;
solveGreedyOrth(Y, X, mu, max_iter);
timeGreedy = toc;
%% Print the results
fprintf('Run time for Regularization = %f.\n', timeMLMTL)
fprintf('Run time for Greedy = %f.\n', timeGreedy)
fprintf('Speedup = %f\n', timeMLMTL/timeGreedy)

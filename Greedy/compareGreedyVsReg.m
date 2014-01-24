% Comparing the speed of two algorithms
clc
clear

addpath('./GreedySubFunc/')
addpath(genpath('../MLMTL/'))
addpath('../TTI/nway331/')

% load('../data/climateP17.mat')
load synthBench.mat
nLag = 1;
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
Lambda = logspace(-4, 5, 10); %%%%%%%%
beta = 2e-2;

err = 0*Lambda;
err2 = err;
ranks = 0*Lambda;
trcomp = 0*Lambda;
for i = 1:length(Lambda)
    tic
    [~, SolConv] = MLMTL_Mixture( X, Y, indicators, beta, Lambda(i), 150);
    toc
    SolConv = SolConv.data;
    [err(i), ranks(i), trcomp(i)] = testQuality2(SolConv, A);
    disp(i)
end
qualityNuc = [err; ranks; trcomp];

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
test.X = [];
test.Y = [];

mu = 1e-4;
max_iter = 10;
tic
[~, qualityGreedy] = solveGreedyOrth(Y, X, mu, max_iter, A, test);
toc
save('tempBench.mat', 'qualityNuc', 'Lambda', 'qualityGreedy')
%% Print the results
load tempBench.mat
plot(qualityNuc(1, :), qualityNuc(2, :), 'o', 'LineWidth',3)
hold on
plot(qualityGreedy(:, 2), qualityGreedy(:, 3), '^', 'LineWidth',3)

% figure
% 
% scatter(sqrt(qualityNuc(1, :)), qualityNuc(3, :), 'b', 'LineWidth',1.5)
% hold on
% scatter(sqrt(qualityGreedy(:, 1)), qualityGreedy(:, 3), '^', 'LineWidth',1.5)

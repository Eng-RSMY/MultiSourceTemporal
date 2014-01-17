% Comparing the speed of two algorithms
clc
clear

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
    for ll = 1:size(SolConv, 2)
        err(i) = err(i) + norm(A-squeeze(SolConv(:, ll, :)), 'fro')^2;
    end
    for ll = 1:size(SolConv, 2)
        err2(i) = err2(i) + norm(A-squeeze(SolConv(:, ll, :))', 'fro')^2;
    end
    ranks(i) = ranks(i) + rank(unfld(SolConv, 1));
    ranks(i) = ranks(i) + rank(unfld(SolConv, 2));
    ranks(i) = ranks(i) + rank(unfld(SolConv, 3));
    trcomp(i) = TRComplexity(SolConv);
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

mu = 1e-4;
max_iter = 10;
tic
[~, qualityGreedy] = solveGreedyOrth(Y, X, mu, max_iter, A);
toc
%% Print the results
scatter(sqrt(qualityNuc(1, :)), qualityNuc(2, :), 'b', 'LineWidth',1.5)
hold on
scatter(sqrt(qualityGreedy(:, 1)), qualityGreedy(:, 2), '^', 'LineWidth',1.5)

figure

scatter(sqrt(qualityNuc(1, :)), qualityNuc(3, :), 'b', 'LineWidth',1.5)
hold on
scatter(sqrt(qualityGreedy(:, 1)), qualityGreedy(:, 3), '^', 'LineWidth',1.5)

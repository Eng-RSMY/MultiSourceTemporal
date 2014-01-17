% Run Climate
clc
clear

load('../data/climateP17.mat')
nLag = 3;
nTask = length(series);
[nLoc, tLen] = size(series{1});
tTrain = floor(0.6*tLen);
tTest = tLen - tTrain;

global verbose
verbose = 1;
global evaluate
evaluate = 1;

%% Create the matrices
A = zeros(nLoc);
X = cell(nTask, 1);
Y = cell(nTask, 1);
test.X = cell(nTask, 1);
test.Y = cell(nTask, 1);
for i = 1:nTask
    Y{i} = series{i}(:, nLag+1:tTrain);
    X{i} = zeros(nLag*nLoc, (tTrain - nLag));
    for ll = 1:nLag
        X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, nLag+1-ll:tTrain-ll);
    end
    test.Y{i} = series{i}(:, tTrain-nLag+1:tLen);
    for ll = 1:nLag
        test.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, tTrain-nLag+1-ll:tLen-ll);
    end
end

mu = 1e-8;
max_iter = 20;
tic
[~, qualityGreedy] = solveGreedyOrth(Y, X, mu, max_iter, A, test);
toc
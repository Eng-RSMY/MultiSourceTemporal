% Run Climate
clc
clear

global verbose
verbose = 0;
global evaluate
evaluate = 1;

addpath(genpath('../Greedy/'))
load('../data/climateP17.mat')
load('Group_idx')
nLag = 1;
nTask = length(unique(idx));
indexes = cell(nTask, 1);
for i = 1:nTask
    indexes{i} = find(idx == i);
end

[nLoc, tLen] = size(series{1});
tTrain = floor(0.9*tLen);
tTest = tLen - tTrain;
nLoc2 = nLoc/nTask;
% Create the matrices
qualityGreedy = zeros(length(series), 1);
for k = 5:length(series)
    A = zeros(nLoc2, nLoc, nTask);
    X = cell(nTask, 1);
    Y = cell(nTask, 1);
    test.X = cell(nTask, 1);
    test.Y = cell(nTask, 1);
    for i = 1:nTask
        Y{i} = series{k}(indexes{i}, nLag+1:tTrain);
        X{i} = zeros(nLoc, (tTrain - nLag));
        for ll = 1:nLag
            X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{k}(:, nLag+1-ll:tTrain-ll);
        end
        test.Y{i} = series{k}(indexes{i}, tTrain-nLag+1:tLen);
        for ll = 1:nLag
            test.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{k}(:, tTrain-nLag+1-ll:tLen-ll);
        end
    end
    
    mu = 1e-8;
    max_iter = 100;
    [~, tempQuality] = solveGreedy(Y, X, mu, max_iter, A, test);
    qualityGreedy(k) = min(tempQuality(2:end, 5));
    disp(k)
end
save('qualityForGeo.mat', 'qualityGreedy')
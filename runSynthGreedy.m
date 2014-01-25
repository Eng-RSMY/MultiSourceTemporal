function [qFor, qOrth] = runSynthGreedy(name)
load(['./data/synth/datasets/' name])

[~, nLoc, nTask] = size(A);
tTrain = size(tr_series{1}, 2);
tTest = size(te_series{1}, 2);
tValid = size(v_series{1}, 2);
nLag = 1;
mu = 1e-10;     % Eliminate the effect of mu 
max_iter = 50;  % Run the greedy algorithm for these many steps
% Settings for Regularized version

train.X = cell(nTask, 1); train.Y = cell(nTask, 1);
valid.X = cell(nTask, 1); valid.Y = cell(nTask, 1);
test.X = cell(nTask, 1); test.Y = cell(nTask, 1);
for i = 1:nTask
    train.Y{i} = tr_series{i}(:, nLag+1:tTrain);
    train.X{i} = zeros(nLag*nLoc, (tTrain - nLag));
    for ll = 1:nLag
        train.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = tr_series{i}(:, nLag+1-ll:tTrain-ll);
    end
    valid.Y{i} = v_series{i}(:, nLag+1:tValid);
    valid.X{i} = zeros(nLag*nLoc, (tValid - nLag));
    for ll = 1:nLag
        valid.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = v_series{i}(:, nLag+1-ll:tValid-ll);
    end
    test.Y{i} = te_series{i}(:, nLag+1:tTest);
    test.X{i} = zeros(nLag*nLoc, (tTest - nLag));
    for ll = 1:nLag
        test.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = te_series{i}(:, nLag+1-ll:tTest-ll);
    end
end

global evaluate
evaluate = 1;

%% Forward Greedy
[~, qualityGreedy] = solveGreedy(train.Y, train.X, mu, max_iter, A, valid);
[~, ix] = min(qualityGreedy(2:end, 5));
max_iter2 = ix;
evaluate = 0;
tic
Sol = solveGreedy(train.Y, train.X, mu, max_iter2, A, valid);
timeGreed = toc;
qualityGreedy = testQuality(Sol, A, test.X, test.Y);
qFor = [qualityGreedy', timeGreed];

%% Orth Greedy
[~, qualityGreedy] = solveGreedyOrth(train.Y, train.X, mu, max_iter, A, valid);
[~, ix] = min(qualityGreedy(2:end, 5));
max_iter2 = ix;
evaluate = 0;
tic
Sol = solveGreedyOrth(train.Y, train.X, mu, max_iter2, A, valid);
timeGreed = toc;
qualityGreedy = testQuality(Sol, A, test.X, test.Y);
qOrth = [qualityGreedy', timeGreed];
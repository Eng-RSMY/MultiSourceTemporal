function [ qTucker ] = runSynthTucker( name )
%RUNSYNTHTUCKER Summary of this function goes here
%   Detailed explanation goes here
load(['./data/synth/datasets3/' name])
global verbose
verbose = 0;
[~, nLoc, nTask] = size(A);
tTrain = size(tr_series{1}, 2);
tTest = size(te_series{1}, 2);
tValid = size(v_series{1}, 2);
nLag = 1;
% lamResolution = 5; 
% Lambda = logspace(-3, 3, lamResolution); 

Lambda = 0.5;
% Format the datasets
train.X = cell(nTask*nLoc, 1);  train.Y = train.X;
valid.X = cell(nTask*nLoc, 1);  valid.Y = valid.X;
test.X = cell(nTask*nLoc, 1);  test.Y = test.X;

for i = 1:nTask
    for j = 1:nLoc
        % Training
        train.Y{j+(i-1)*nLoc} = tr_series{i}(j, nLag+1:tTrain)';
        train.X{j+(i-1)*nLoc} = zeros(nLag*nLoc, (tTrain - nLag));
        for ll = 1:nLag
            train.X{j+(i-1)*nLoc}(nLoc*(ll-1)+1:nLoc*ll, :) = tr_series{i}(:, nLag+1-ll:tTrain-ll);
        end
        % Validation
        valid.Y{j+(i-1)*nLoc} = v_series{i}(j, nLag+1:tValid)';
        valid.X{j+(i-1)*nLoc} = zeros(nLag*nLoc, (tValid - nLag));
        for ll = 1:nLag
            valid.X{j+(i-1)*nLoc}(nLoc*(ll-1)+1:nLoc*ll, :) = v_series{i}(:, nLag+1-ll:tValid-ll);
        end
        % Testing
        test.Y{j+(i-1)*nLoc} = te_series{i}(j, nLag+1:tTest)';
        test.X{j+(i-1)*nLoc} = zeros(nLag*nLoc, (tTest - nLag));
        for ll = 1:nLag
            test.X{j+(i-1)*nLoc}(nLoc*(ll-1)+1:nLoc*ll, :) = te_series{i}(:, nLag+1-ll:tTest-ll);
        end
    end
end

% Run the regularized code
indicators = [nLoc*nLag, nTask, nLoc];

% Training phase
% for i = 1:length(Lambda)
%     [~, Sol] = MLMTL_Tucker( train.X, train.Y, indicators,Lambda(i));
%     Sol = Sol.data;
%     [~, ~, ~, err(i)] = testQuality2(Sol, A, valid.Y, valid.X);
%     if verbose; fprintf('Reg: %d\n', Lambda(i)); end
% end
% % Final evaluations
% [~, ix] = min(err);
ix = 1;
tic
[~, Sol] = MLMTL_Tucker( train.X, train.Y, indicators, Lambda(ix));
timeReg = toc;
Sol = Sol.data;
[errReg, lrcompReg, trcompReg, predReg] = testQuality2(Sol, A, test.Y, test.X);
qTucker = [errReg, lrcompReg, trcompReg, predReg, timeReg];



end


function [qRegC, qRegM] = runSynthNuc(name)
load(name)
global verbose
[~, nLoc, nTask] = size(A);
tTrain = size(tr_series{1}, 2);
tTest = size(te_series{1}, 2);
tValid = size(v_series{1}, 2);
nLag = 1;
lamResolution = 15; 
Lambda = logspace(-5, 5, lamResolution); 
beta = 2e-2;

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

errC = 0*Lambda;
errM = errC;
% Training phase
for i = 1:length(Lambda)
%     [~, SolMix] = MLMTL_Mixture( train.X, train.Y, indicators, beta, Lambda(i), 250);
%     SolMix = SolMix.data;
%     [~, ~, ~, errM(i)] = testQuality2(SolMix, A, valid.Y, valid.X);
    [~, SolConv] = MLMTL_Convex( train.X, train.Y, indicators, beta, Lambda(i), 250);
    SolConv = SolConv.data;
    [~, ~, ~, errC(i)] = testQuality2(SolConv, A, valid.Y, valid.X);
    if verbose; fprintf('Reg: %d\n', Lambda(i)); end
end
% Final evaluations
% [~, ix] = min(errM);
% tic
% [~, SolMix] = MLMTL_Mixture( train.X, train.Y, indicators, beta, Lambda(ix), 250);
% timeReg = toc;
% SolMix = SolMix.data;
% [errReg, lrcompReg, trcompReg, predReg] = testQuality2(SolMix, A, test.Y, test.X);
% qRegM = [errReg, lrcompReg, trcompReg, predReg, timeReg];
qRegM = zeros(1,5);

[~, ix] = min(errC);
tic
[~, SolConv] = MLMTL_Convex( train.X, train.Y, indicators, beta, Lambda(ix), 250);
timeReg = toc;
SolConv = SolConv.data;
[errReg, lrcompReg, trcompReg, predReg] = testQuality2(SolConv, A, test.Y, test.X);
qRegC = [errReg, lrcompReg, trcompReg, predReg, timeReg];
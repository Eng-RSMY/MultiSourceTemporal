function runTimes = runSynthSpeedup(nTask, tTrain)
% nTask = 10;
% tTrain = 100;

% Dataset settings
rankTensor = 2;     % The CP rank of the tensor
nLoc = 50;
spRatio = floor(0.75*nLoc);   % How sparse the singular vectors should be
sig = 0.2;  % Noise Variance

% Running settings
% Settings for Greedy
nLag = 1;
mu = 1e-10;     % Eliminate the effect of mu 
max_iter = 5;  % Run the greedy algorithm for these many steps
% Settings for Regularized version
Lambda = 10; 
maxIterNuc = 500;
beta = 2e-2;
%% Create the dataset
% Creating the tensor
A = zeros(nLoc, nLoc, nTask);
for i = 1:rankTensor
    u = zeros(nLoc, 1); v = u;
    uInd = randperm(nLoc); vInd = randperm(nLoc);
    u(uInd(1:spRatio)) = 1; v(vInd(1:spRatio)) = 1;
    u = 0.9*u/norm(u); v = v/norm(v);
    AA = u*v';
    w = 0.9 + 0.1*rand(nTask, 1);
    for j = 1:nTask
        A(:, :, j) = w(j)*AA;
    end
end

% Creating the series
tr_series = cell(nTask, 1);
for j = 1:nTask
    % Training
    tr_series{j} = zeros(nLoc, tTrain);
    tr_series{j}(:, 1) = randn(nLoc, 1);
    for t = 2:tTrain
        tr_series{j}(:, t) = squeeze(A(:, :, j))*tr_series{j}(:, t-1) + sig*randn(nLoc, 1);
    end
end
%% Run the Regularized
% Format the datasets
train.X = cell(nTask*nLoc, 1);  train.Y = train.X;

for i = 1:nTask
    for j = 1:nLoc
        % Training
        train.Y{j+(i-1)*nLoc} = tr_series{i}(j, nLag+1:tTrain)';
        train.X{j+(i-1)*nLoc} = zeros(nLag*nLoc, (tTrain - nLag));
        for ll = 1:nLag
            train.X{j+(i-1)*nLoc}(nLoc*(ll-1)+1:nLoc*ll, :) = tr_series{i}(:, nLag+1-ll:tTrain-ll);
        end
    end
end
% Run the regularized code
indicators = [nLoc*nLag, nTask, nLoc];

tic
% MLMTL_Mixture( train.X, train.Y, indicators, beta, Lambda, maxIterNuc);
timeMix = toc;
tic
% MLMTL_Convex( train.X, train.Y, indicators, beta, Lambda, maxIterNuc);
timeConv = toc;

%% Run the Greedy Algorithms
train.X = cell(nTask, 1); train.Y = cell(nTask, 1);
valid.X = cell(nTask, 1); valid.Y = cell(nTask, 1);
for i = 1:nTask
    train.Y{i} = tr_series{i}(:, nLag+1:tTrain);
    train.X{i} = zeros(nLag*nLoc, (tTrain - nLag));
    for ll = 1:nLag
        train.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = tr_series{i}(:, nLag+1-ll:tTrain-ll);
    end
end
global evaluate
evaluate = 0;
tic
solveGreedy(train.Y, train.X, mu, max_iter, A, valid);
timeFor = toc;
tic
solveGreedyOrth(train.Y, train.X, mu, max_iter, A, valid);
timeOrth = toc;
%% Output
runTimes = [timeMix, timeConv, timeFor, timeOrth];
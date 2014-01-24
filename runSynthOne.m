function runSynthOne
% The goal of this function is to evaluate the performance of the
% algorithms on the given dataset length
global verbose
addpath(genpath('./Greedy/'))
addpath(genpath('./MLMTL/'))
addpath('./TTI/nway331/')

% Dataset settings
rankTensor = 2;     % The CP rank of the tensor
tTrain = 100;
tValid = 100;
tTest = 100;

nLag = 1;
nTask = 10;
nLoc = 20;
spRatio = floor(0.25*nLoc);   % How sparse the singular vectors should be
sig = 0.2;  % Noise Variance
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
v_series = cell(nTask, 1);
te_series = cell(nTask, 1);
for j = 1:nTask
    % Training
    tr_series{j} = zeros(nLoc, tTrain);
    tr_series{j}(:, 1) = randn(nLoc, 1);
    for t = 2:tTrain
        tr_series{j}(:, t) = squeeze(A(:, :, j))*tr_series{j}(:, t-1) + sig*randn(nLoc, 1);
    end
    % Validation
    v_series{j} = zeros(nLoc, tValid);
    v_series{j}(:, 1) = randn(nLoc, 1);
    for t = 2:tValid
        v_series{j}(:, t) = squeeze(A(:, :, j))*v_series{j}(:, t-1) + sig*randn(nLoc, 1);
    end
    % Testing
    te_series{j} = zeros(nLoc, tTest);
    te_series{j}(:, 1) = randn(nLoc, 1);
    for t = 2:tTest
        te_series{j}(:, t) = squeeze(A(:, :, j))*v_series{j}(:, t-1) + sig*randn(nLoc, 1);
    end
end
%% Run the Regularized
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
Lambda = logspace(-4, 5, 2); 
beta = 2e-2;

err = 0*Lambda;
% Training phase
for i = 1:length(Lambda)
    [~, SolConv] = MLMTL_Mixture( train.X, train.Y, indicators, beta, Lambda(i), 500);
    SolConv = SolConv.data;
    [~, ~, ~, err(i)] = testQuality2(SolConv, A, valid.Y, valid.X);
    if verbose; disp(i); end
end
tic
[~, ix] = min(err);
[~, SolConv] = MLMTL_Mixture( X, Y, indicators, beta, Lambda(ix), 500);
timeReg = toc;
SolConv = SolConv.data;
[errReg, lrcompReg, trcompReg, predReg] = testQuality2(SolConv, A, test.Y, test.X);
%% Run the Greedy Algorithm

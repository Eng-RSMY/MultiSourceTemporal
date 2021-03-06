% Find 17 dependency matrices
clc
clear

addpath(genpath('./'))
% Load the main dataset here
load climateP17.mat
% Load the solution here
load './Greedy/orthClimate17Sol.mat'
lrSol = Sol;

global verbose
verbose = 0;

nType = length(series);
Sol = cell(nType, 1);
T = size(series{1}, 2);
nLag = 1;   % To avoid high dimensionality
grad = {@gradGaussian, 'Gaussian', lrSol};

tTrain = 140;
testSeries = cell(nType, 1);
for i = 1:nType
    testSeries{i} = series{i}(:, tTrain+1-nLag:end);
end

T = tTrain;     % A little bit of hacking

% For crossvalidation
Lambda_S = logspace(-7, 0, 20);
nCV = 5;
index = cell(nCV, 1);
ind = nLag + randperm(T-nLag);
step = T/nCV;
for i = 1:nCV-1
    index{i} = ind((i-1)*step+1:i*step);
end
index{nCV} = ind((nCV-1)*step+1:end);

findex{1} = nLag+1:T-1;
findex{2} = T;
errL = zeros(size(Lambda_S));
for k = 1:nType
    % Do the cross validation
    grad{3} = squeeze(lrSol(:, :, k));
    parfor j = 1:length(Lambda_S)
        normerr = zeros(nCV, 1);
        lambda = Lambda_S(j);
        
        for i = 1:nCV
            ind = cell(2, 1); ind{1} = []; ind{2} = index{i};
            for ll = 1:nCV;  if ll ~= i;  ind{1} = [ind{1}, index{ll}];  end;  end
            [~, ~, normerr(i)] = sparseGLARP(series{k}, lambda, nLag, ind, grad);
        end
        errL(j) = sum(normerr);
    end
    [~, ix] = min(errL);
    Lambda_1 = Lambda_S(ix(end));
    
    % Final Evaluation
    Sol{k} = sparseGLARP(series{k}, Lambda_1, nLag, findex, grad);
    fprintf('Iteration: %d\n', k)
    save('climate17Results.mat', 'Sol')
end
Sol2 = zeros(125, 125, 17);
for i = 1:17
    Sol2(:, :, i) = Sol{i};
end
A = zeros(125, 125, 17);
quality = testQuality3(Sol2+lrSol, A, testSeries);
save('climate17ResultsSLR.mat', 'Sol', 'quality', 'Sol2')
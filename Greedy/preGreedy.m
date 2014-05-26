
clc
clear

addpath('./GreedySubFunc/')
addpath('../TTI/nway331/')
addpath(genpath('../MLMTL/'))
load('../data/climateP17.mat')
% load('../data/climateP4.mat')
% load('../data/synth/datasets/synth200_9.mat')
% load('../data/Foursquare/norm_4sq.mat')
sigma = 2;
mu = 0.1;
nTask = length(series);
[nLoc, tLen] = size(series{1});

global verbose
verbose = 1;
global evaluate
evaluate = 0;

%% Create the matrices
testIndex = 1:10;

A = 0;
X = cell(nTask, 1);
Y = cell(nTask, 1);
test.X = cell(nTask, 1);
test.Y = cell(nTask, 1);
index = ones(nLoc, 1);
index(testIndex) = 0;
Iomega = diag( index);
sim = mu * euclidSim(locations, sigma);
for i = 1:nTask
    Q = chol(Iomega + sim);
    M = (Q')\(Iomega*series{i});
    Y{i} = M';
    X{i} = Q';
end

mu = 1e-10;
max_iter = 200;
[Sol, qualityGreedy] = solveGreedyOrth(Y, X, mu, max_iter, A, test);

rmse = 0;
for i = 1:nTask
    rmse = rmse + norm(squeeze(Sol(:, testIndex, i))' - series{i}(testIndex, :), 'fro')^2;
end
rmse = sqrt(rmse/tLen/nTask/length(testIndex));
disp(rmse)
% save('qualityFor4Sq.mat', 'qualityGreedy')
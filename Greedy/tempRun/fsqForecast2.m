clc
clear

addpath(genpath('../../'))
load('../../data/Foursquare/norm_4sq_small.mat')

% For Euclidian
% sigma = 2;
% mu = 18.3486;
% For Harversine
sigma = 0.1;  % Should be selected in a way that effectively few neighbors get weights

% nTask = length(series);
[nLoc, tLen] = size(series{1});

global verbose
verbose = 1;
global evaluate
evaluate = 3;

sim = sim/(max(sim(:)));       % The goal is to balance between two measures
sim(logical(eye(size(sim)))) = max(sim(:));
sim = diag(sum(sim)) - sim + (1e-5)*eye(nLoc);

nLag = 5;
nTask = length(series);
tTrain = 1080+nLag;
tTest = tLen - tTrain;
% Create the matrices
A = zeros(nLoc, nLoc*nLag, nTask);
X = cell(nTask, 1);
Y = cell(nTask, 1);
test.X = cell(nTask, 1);
test.Y = cell(nTask, 1);

mu = logspace(-1, 1.3, 10);

ep = 1e-10;
max_iter = 151;
quality = zeros(max_iter-1, length(mu));
for m = 1:length(mu)
    U = chol(eye(nLoc) + mu(m)*sim);
    for i = 1:nTask
        Y{i} = series{i}(:, nLag+1:tTrain);
        Y{i} = (U')\Y{i};               % This is the transformation
        test.Y{i} = series{i}(:, tTrain-nLag+1:tLen);
        X{i} = zeros(nLag*nLoc, (tTrain - nLag));
        for ll = 1:nLag
            X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, nLag+1-ll:tTrain-ll);
            test.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, tTrain-nLag+1-ll:tLen-ll);
        end
    end
    
    [~, tmp] = solveGreedy(Y, X, ep, max_iter, U, test);
    quality(:, m) = tmp(:, 2);
end
save('ForecastingFor4sq.mat', 'quality')
% save('krigingOrtho.mat', 'quality')

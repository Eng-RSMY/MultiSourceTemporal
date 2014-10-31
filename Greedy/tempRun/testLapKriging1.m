clc
clear

addpath(genpath('../../'))
load('../../data/climateP17.mat')
load('../../data/climateP17_missIdx.mat')
% load('../data/climateP4.mat')
% load('../data/synth/datasets/synth200_9.mat')
% load('../data/Foursquare/norm_4sq.mat')

% For Euclidian
% sigma = 2;
% mu = 18.3486;
% For Harversine
sigma = 0.1;  % Should be selected in a way that effectively few neighbors get weights
mu = 10;
nTask = length(series);
[nLoc, tLen] = size(series{1});

global verbose
verbose = 1;
global evaluate
evaluate = 2;

locations = names(:, 2:3);
% sim =  euclidSim(locations, sigma);
% sim = haverSimple(locations, sigma);

% Here I generate a bad similarity matrix
sim = zeros(nLoc);

for i = 1:nLoc
    for j = 1:nLoc
        for t = 1:nTask
            sim(i, j) = sim(i, j) + (series{t}(i, :)*series{t}(j, :)')/norm(series{t}(i, :))/norm(series{t}(j, :));
        end
    end
end

max_iter = 251;
quality = zeros(max_iter-1, size(idx_Missing, 2));
% Create the matrices
for i = 1:size(idx_Missing, 2)
    testIndex = idx_Missing(:, i);
    surr = mean(sim(:, setdiff(1:nLoc, testIndex)), 2);
    sim2 = sim;
    sim2(testIndex, :) = ones(length(testIndex), 1)*surr';
    sim2(:, testIndex) = surr*ones(1, length(testIndex));
    sim2(logical(eye(nLoc))) = nTask;
    sim2 = sim2/(max(sim2(:)));       % The goal is to balance between two measures
    sim2 = diag(sum(sim2)) - sim2;
    sim2 = sim2 + (1e-3)*eye(nLoc);
    
    index = ones(nLoc, 1);
    index(testIndex) = 0;
    Iomega = diag( index);
    
    ep = 1e-10;
    mu = logspace(0, 2, 10);
    quality(:, i) =  prepareData(series, Iomega, 5, sim2, max_iter, ep, testIndex, 'solveGreedyOrth');
    disp(i)
end

save('KrigingOrthoMultiIndex.mat', 'quality')
% save('krigingOrtho.mat', 'quality')

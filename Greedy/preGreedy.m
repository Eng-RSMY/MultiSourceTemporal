clc
clear

addpath(genpath('../'))
load('../data/climateP17.mat')
load('../data/climateP17_missIdx.mat')
% load('../data/climateP4.mat')
% load('../data/synth/datasets/synth200_9.mat')
% load('../data/Foursquare/norm_4sq.mat')

% For Euclidian
% sigma = 2;
% mu = 18.3486;
% For Harversine
sigma = 0.1;  % Should be selected in a way that effectively few neighbors get weights
mu = 5;
% nTask = length(series);
[nLoc, tLen] = size(series{1});

global verbose
verbose = 1;
global evaluate
evaluate = 2;


% sim =  euclidSim(locations, sigma);
sim = haverSimple(locations, sigma);
sim = sim/(max(sim(:)));       % The goal is to balance between two measures

max_iter = 251;
quality = zeros(max_iter-1, size(idx_Missing, 2));
% Create the matrices
for i = 1:size(idx_Missing, 2)
    testIndex = idx_Missing(:, i);
    
    index = ones(nLoc, 1);
    index(testIndex) = 0;
    Iomega = diag( index);
    
    ep = 1e-10;
    mu = logspace(0, 2, 10);
    quality(:, i) =  prepareData(series, Iomega, 5, sim, max_iter, ep, testIndex);
    disp(i)
end

save('KrigingOrthoMultiIndex.mat', 'quality')
% save('krigingOrtho.mat', 'quality')

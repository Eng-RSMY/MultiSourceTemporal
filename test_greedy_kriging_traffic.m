% test traffic data with greedy algorithm
clear;
clc;
addpath(genpath('./'));

load 'dense_highway_april.mat'
load 'idx_missing_dense.mat'

% load 'sparse_highway_april.mat'
% load 'idx_missing_sparse.mat'


[nLoc, tLen,num_var]  = size(series);
series_cell = cell(num_var, 1);
for var = 1:num_var
    series_cell{var} = series(:,:,var);
end

 
sigma = 0.01;  % Should be selected in a way that effectively few neighbors get weights
mu = 5;
% nTask = length(series);

global verbose
verbose = 1;
global evaluate
evaluate = 2;

sim = haverSimple(latlng, sigma);
sim = sim/(max(sim(:)));       % The goal is to balance between two measures

max_iter = 6;
num_random_folds =  size(idx_missing, 2);
quality = zeros(max_iter-1, num_random_folds);
quality_nonzero = zeros(max_iter-1, num_random_folds );
Sols = cell(1,num_random_folds);

% Create the matrices
for i = 1: size(idx_missing, 2)
    testIndex = find(idx_missing(:,i)==1);   
    Iomega = diag(idx_missing(:,i));
   
    ep = 1e-10;
    mu = logspace(0, 2, 10);
    [Sols{i}, quality(:, i),quality_nonzero(:,i)] =  prepareData2(series_cell, Iomega, 5, sim, max_iter, ep, testIndex, 'solveGreedy2');
    disp(i)
end   

save('result/traffic/greedy_dense_highway.mat','Sols','quality', 'quality_nonzero');

mean(quality(end,:))
mean(quality_nonzero(end,:))
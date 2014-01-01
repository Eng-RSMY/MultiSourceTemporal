% Find 17 dependency matrices
clc
clear

load climateP17.mat

global verbose
verbose = 1;
addpath(genpath('./'))

nType = length(series);
Sol = cell(nType, 1);
nLag = 1;
lambda = 1e-4;
index{1} = nLag+1:size(series{1}, 2);
index{2} = [];
grad = {@gradGaussian, 'Gaussian'};
for i = 1:nType
    [tempSol, err, normerr] = sparseGLARP(series{i}, lambda, nLag, index, grad);
    Sol{i} = tempSol{1};
end

save('climate17Results.mat', 'Sol')
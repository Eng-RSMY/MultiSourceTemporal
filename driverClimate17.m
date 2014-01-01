% Find 17 dependency matrices
clc
clear

addpath(genpath('./'))
load climateP17.mat

global verbose
verbose = 0;

nType = length(series);
Sol = cell(nType, 1);
T = size(series{1}, 2);
nLag = 1;   % To avoid high dimensionality
grad = {@gradGaussian, 'Gaussian'};

% For crossvalidation
Lambda_S = logspace(-7, -2, 24);
nCV = 6;
index = cell(nCV, 1);
ind = nLag + randperm(T-nLag);
step = T/nCV;
for i = 1:nCV-1
    index{i} = ind((i-1)*step+1:i*step);
end
index{nCV} = ind((nCV-1)*step+1:end);

errL = zeros(size(Lambda_S));
for k = 1:nType
    % Do the cross validation
    parfor j = 1:length(Lambda_S)
        normerr = zeros(nCV, 1);
        lambda = Lambda_S(j);
        
        for i = 1:nCV
            ind = cell(2, 1); ind{1} = []; ind{2} = index{i};
            for ll = 1:nCV;  if ll ~= i;  ind{1} = [ind{1}, index{ll}];  end;  end
            [~, ~, normerr(i)] = sparseGLARP(series{k}, lambda, nLag, ind, grad);
        end
        fprintf('Iteration: %d\n', j)
        errL(j) = sum(normerr);
    end
    [~, ix] = min(errL);
    Lambda_1 = Lambda_S(ix(end));
    
    % Final Evaluation
    index{1} = nLag+1:T-1;
    index{2} = T;
    tempSol = sparseGLARP(series{k}, Lambda_1, nLag, index, grad);
    Sol{k} = tempSol{1};
end

save('climate17Results.mat', 'Sol')
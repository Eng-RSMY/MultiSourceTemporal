clear all
clc
close all

addpath(genpath('./'))

load temp.mat
obs = obs';

% load('./data/Foursquare/active_checkin.mat');
% obs = active_checkin_counts;


obs = obs - mean(obs, 2)*ones(1, size(obs, 2));
obs = obs./(std(obs, 0, 2)*ones(1, size(obs, 2)));
series = obs;

global verbose
verbose = 0;
T = size(series, 2);
grad = {@gradGaussian, 'Gaussian'};

Lambda_S = logspace(-6, -3, 12);
nLag = 4;
nCV = 4;
index = cell(nCV, 1);
ind = nLag + randperm(T-nLag);
step = T/nCV;
for i = 1:nCV-1
    index{i} = ind((i-1)*step+1:i*step);
end
index{nCV} = ind((nCV-1)*step+1:end);
errL = zeros(size(Lambda_S));
for j = 1:length(Lambda_S)
    normerr = zeros(nCV, 1);
    lambda = Lambda_S(j);
    
    for i = 1:nCV
        ind = cell(2, 1); ind{1} = []; ind{2} = index{i};
        for ll = 1:nCV;  if ll ~= i;  ind{1} = [ind{1}, index{ll}];  end;  end
        [~, ~, normerr(i)] = sparseGLARP(series, lambda, nLag, ind, grad);
    end
    fprintf('Iteration: %d\n', j)
    errL(j) = sum(normerr);
end
[~, ix] = min(errL);
Lambda_1 = Lambda_S(ix(end));
%% Final Evaluation
verbose = 1;
i = 2;
index{1} = nLag+1:T-1;
index{2} = T;
[Sol, err, normerr] = sparseGLARP(series, Lambda_1, nLag, index, grad);





% nLag = 3;
% T = size(series{1}, 2);
% Ttest = 10;
% index{1} = nLag+1:T-Ttest;
% index{2} = T-Ttest+1:T;
% [Sol, err, normerr] = coreg(series, TLam, lambda, nLag, index);

% grad = {@gradGaussian, 'Gaussian'};
% grad = {@gradGumbel, 'Gumbel'};
% [S, err, normerr] = sparseGLARP(series{1}, lambda(2), nLag, index, grad);
% disp(err)
% disp(normerr)

% load wind.mat
% obs = obs - ones(size(obs, 1), 1)*mean(obs, 1);
% obs = obs./(ones(size(obs, 1), 1)*std(obs, 0, 1));
% series{2} = obs';
% load rain.mat
% series{3} = (obs > 0.01)'*1.0;
% clear obs pars  % Housekeeping
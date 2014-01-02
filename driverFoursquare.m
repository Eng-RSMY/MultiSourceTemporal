% Find 17 dependency matrices
clc
clear

addpath(genpath('./'))
load 'tensor_checkin_counts.mat'
series = cell( length(tensor_checkin_counts), 1 );
nLoc = size(tensor_checkin_counts{1}, 1);
tLen = size(tensor_checkin_counts{1}, 2);
step = 6;
for i = 1:length(series)
    series{i} = zeros(nLoc, floor(tLen/step));
    for t = 1:floor(tLen/step)
        series{i}(:, t) = sum(tensor_checkin_counts{i}(:, step*(t-1)+1:step*t), 2);
    end
end


global verbose
verbose = 0;

global draw
draw = 0;

nType = length(series);
Sol = cell(nType, 1);
T = size(series{1}, 2);
nLag = 5;   % To avoid high dimensionality
grad = {@gradPoisson, 'Poisson'};

% For crossvalidation
Lambda_S = logspace(-7, -3, 10);

nCV = 5;
index = cell(nCV, 1);
ind = nLag + randperm(T-nLag);
step = floor(T/nCV); % take the integer
for i = 1:nCV-1
    index{i} = ind((i-1)*step+1:i*step);
end
index{nCV} = ind((nCV-1)*step+1:end);

errL = zeros(size(Lambda_S));
findex{1} = nLag+1:T;
findex{2} = [];

for k = 1:length(series)
    % Do the cross validation
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
    save('tensor_4SQ_Results.mat', 'Sol')
end

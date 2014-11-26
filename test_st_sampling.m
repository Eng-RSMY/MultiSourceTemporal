% test for spatio-temporal sampling
clear;
addpath(genpath('.'));
load 'climateP17.mat'
num_var = length(series);
variable_idx = 1;
time_series = series{variable_idx};
[num_loc, num_ts] = size(time_series);

%% compute similarity matrix
L = zeros(num_loc, num_loc);
obs = [];
% for var = 1:num_var
%     obs = [obs,series{var}];
% end
obs = [series{:}];
for i = 1:num_loc
    for j = i:num_loc
        L(i,j) = obs(i,:)* obs(j,:)';
        L(j,i) =  L(i,j);
    end
end

%% sample with DPP
num_sample = 50;
dpp_sample = sample_dpp(decompose_kernel(L), num_sample);

%% evaluate kriging performances with greedy
tic 
idx_missing_dpp = setdiff(1:num_loc, dpp_sample)';
sigma = 0.1;  % Should be selected in a way that effectively few neighbors get weights
mu = 5;
% nTask = length(series);
[nLoc, tLen] = size(series{1});

global verbose
verbose = 1;
global evaluate
evaluate = 2;

sim = haverSimple(locations, sigma);
sim = sim/(max(sim(:)));       % The goal is to balance between two measures

max_iter = 11;
quality_dpp = zeros(max_iter-1, size(idx_missing_dpp, 2));
% Create the matrices
for i = 1:size(idx_missing_dpp, 2)
    testIndex = idx_missing_dpp(:, 1);
    
    index = ones(nLoc, 1);
    index(testIndex) = 0;
    Iomega = diag( index);
    
    ep = 1e-10;
    mu = logspace(0, 2, 10);
    quality_dpp(:, i) =  prepareData(series, Iomega, 5, sim, max_iter, ep, testIndex, 'solveGreedy');
    disp(i)
end    
toc

%% sampling with random matrix sampling ( Micheal Mahoney )

% perform SVD of  design matrix
[U Sigma V] =  svds (obs);
leverage_score =  diag(U*U');
[~,rms_sample] = sort(leverage_score,'descend');
rms_sample = rms_sample(1:num_sample);

%%
tic 
idx_missing_rms = setdiff(1:num_loc, rms_sample)';
sigma = 0.1;  % Should be selected in a way that effectively few neighbors get weights
mu = 5;
% nTask = length(series);
[nLoc, tLen] = size(series{1});


sim = haverSimple(locations, sigma);
sim = sim/(max(sim(:)));       % The goal is to balance between two measures

max_iter = 11;
quality_rms = zeros(max_iter-1, size(idx_missing_rms, 2));
% Create the matrices
for i = 1:size(idx_missing_rms, 2)
    testIndex = idx_missing_rms(:, 1);
    
    index = ones(nLoc, 1);
    index(testIndex) = 0;
    Iomega = diag( index);
    
    ep = 1e-10;
    mu = logspace(0, 2, 10);
    quality_rms(:, i) =  prepareData(series, Iomega, 5, sim, max_iter, ep, testIndex, 'solveGreedy');
    disp(i)
end    
toc

%%
hold all;
plot(quality_rms(2:end));
plot(quality_dpp(2:end));
legend('rsm','dpp');
save('./result/sampling/rms_dpp_50sample.mat','quality_dpp','quality_rms','dpp_sample','rms_sample');
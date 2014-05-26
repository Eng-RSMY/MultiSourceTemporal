% Run Climate
clc
clear

addpath('./GreedySubFunc/')
addpath('../TTI/nway331/')
addpath(genpath('../MLMTL/'))
load('../data/climateP17.mat')
% load('../data/climateP4.mat')
% load('../data/synth/datasets/synth200_9.mat')
% load('../data/Foursquare/norm_4sq.mat')
nLag = 3;
nTask = length(series);
[nLoc, tLen] = size(series{1});
tTrain = floor(0.9*tLen);
tTest = tLen - tTrain;

global verbose
verbose = 1;
global evaluate
evaluate = 1;

%% Create the matrices
A = zeros(nLoc, nLoc*nLag, nTask);
X = cell(nTask, 1);
Y = cell(nTask, 1);
test.X = cell(nTask, 1);
test.Y = cell(nTask, 1);
for i = 1:nTask
    Y{i} = series{i}(:, nLag+1:tTrain);
    X{i} = zeros(nLag*nLoc, (tTrain - nLag));
    for ll = 1:nLag
        X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, nLag+1-ll:tTrain-ll);
    end
    test.Y{i} = series{i}(:, tTrain-nLag+1:tLen);
    for ll = 1:nLag
        test.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, tTrain-nLag+1-ll:tLen-ll);
    end
end

mu = 1e-10;
max_iter = 200;
[~, qualityGreedy] = solveGreedyOrth(Y, X, mu, max_iter, A, test);
save('qualityFor4Sq.mat', 'qualityGreedy')
%% The Nuclear norm Solution
% X = cell(nTask*nLoc, 1);
% Y = X;
% for i = 1:nTask
%     for j = 1:nLoc
%         Y{j+(i-1)*nLoc} = series{i}(j, nLag+1:tTrain)';
%         X{j+(i-1)*nLoc} = zeros(nLag*nLoc, (tTrain - nLag));
%         for ll = 1:nLag
%             X{j+(i-1)*nLoc}(nLoc*(ll-1)+1:nLoc*ll, :) = series{i}(:, nLag+1-ll:tTrain-ll);
%         end
%     end
% end
% indicators = [nLoc*nLag, nTask, nLoc];
% beta = 2e-2;
% % Run 
% Lambda = logspace(2, 6, 10);
% errNucAll = zeros(length(Lambda), 2);
% qualityNuc = 0*Lambda;
% parfor i = 1:length(Lambda)
%     [~, SolConv] = MLMTL_Mixture( X, Y, indicators, beta, Lambda(i), 250);
%     SolConv = SolConv.data;
%     
%     errNuc = zeros(1, 2);
%     for ll = 1:nTask
%         errNuc(1) = errNuc(1) + norm(test.Y{ll} - squeeze(SolConv(:, ll, :))*test.X{ll}, 'fro')^2;
%         errNuc(2) = errNuc(1)/mean(test.Y{ll}(:).^2);
%         errNuc(1) = errNuc(1)/numel(test.Y{ll});
%     end
%     errNucAll(i, :) = sqrt(errNuc)/nTask;
%     qualityNuc(i) = qualityNuc(i) + rank(unfld(SolConv, 1));
%     qualityNuc(i) = qualityNuc(i) + rank(unfld(SolConv, 2));
%     qualityNuc(i) = qualityNuc(i) + rank(unfld(SolConv, 3));
%     disp(i)
% end
% 
% save('comparisonResults3.mat', 'Lambda', 'errNucAll', 'errGreedy', 'qualityGreedy', 'qualityNuc')

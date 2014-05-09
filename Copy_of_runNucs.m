% Run Greedies
clc
clear
addpath(genpath('./MLMTL/'))
addpath(genpath('./Greedy/'))

global verbose
verbose = 0;
tLen = [10, 50, 100, 200];
qFor = cell(4, 1);
qOrth = cell(4, 1);


% for t = 1:length(tLen)
%     qFor{t} = zeros(10, 5);
%     qOrth{t} = qFor{t};
%     qForTemp = qFor{t};
%     qOrthTemp = qOrth{t};
%     for i = 1:10
%         path = './data/synth/datasets4/';
%         fname = sprintf('synth%d_%d.mat', tLen(t), i);
%         name= strcat(path, fname);
%         [qForTemp(i, :), qOrthTemp(i, :)] = runSynthNuc(name);
%     end
%     qFor{t} = qForTemp;
%     qOrth{t} = qOrthTemp;
%     save('result/synth/nuclResultsSynth.mat', 'qFor', 'qOrth')
%     disp(t)
% end

%%
Ranks = [1:10];
maxIter = 5;
for rnk = Ranks
    qFor{rnk} = zeros(maxIter, 5);
    qOrth{rnk} = qFor{rnk};
    qForTemp = qFor{rnk};
    qOrthTemp = qOrth{rnk};
    for i = 1:maxIter
        path = './data/synth/datasets5/';
        fname = sprintf('synth_rk%d_%d.mat', rnk, i);
        name= strcat(path, fname);
        [qForTemp(i, :), qOrthTemp(i, :)] = runSynthNuc(name);
    end
    qFor{rnk} = qForTemp;
    qOrth{rnk} = qOrthTemp;
    save('result/synth/nuclResultsSynth_rk2.mat', 'qFor', 'qOrth')
    disp(rnk)
end
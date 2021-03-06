% Run Greedies
clear;
clc;
addpath(genpath('.'));
global verbose
verbose = 0;
tLen = [10, 50, 100, 200];
% qFor = cell(4, 1);
% qOrth = cell(4, 1);
% for t = 1:length(tLen)
%     qFor{t} = zeros(10, 6);
%     qOrth{t} = qFor{t};
%     parfor i = 1:10
%         name = sprintf('synth%d_%d.mat', tLen(t), i);
%         [qForTemp(i, :), qOrthTemp(i, :)] = runSynthGreedy(name);  
%     end
%    
%     qFor{t} = qForTemp;
%     qOrth{t} = qOrthTemp;
%     save('result/synth/greedyResultsSynth.mat', 'qFor', 'qOrth')
%     disp(t)
% end

%% 
% comparison with Ranks 
maxIter = 5;
Ranks = 1:5;
qFor = cell(5, 1);
qOrth = cell(5, 1);
path = './data/synth/datasets5/';
<<<<<<< HEAD
for rnk = 1:Ranks%length(Ranks)
=======
for rnk = 1:length(Ranks)
>>>>>>> d217cc6b8cdd00243ef1e6ec7bd1c8d05781a592
    qFor{rnk} = zeros(maxIter, 6);
    qOrth{rnk} = qFor{rnk};
    parfor i = 1:maxIter
        fname = sprintf('synth_rk%d_%d.mat', rnk, i);
        name = strcat(path, fname);
        [qForTemp(i, :), qOrthTemp(i, :)] = runSynthGreedy(name);  
    end
   
    qFor{rnk} = qForTemp;
    qOrth{rnk} = qOrthTemp;
    save('result/synth/greedyResultsSynth_rk_2_taha.mat', 'qFor', 'qOrth');
    disp(rnk);

end

% Run Greedies
clc
clear
addpath(genpath('../MLMTL/'))
addpath(genpath('../Greedy/'))

global verbose
verbose = 0;
tLen = [10, 50, 100, 200];
qFor = cell(4, 1);
qOrth = cell(4, 1);
for t = 1:length(tLen)
    qFor{t} = zeros(10, 5);
    qOrth{t} = qFor{t};
    qForTemp = qFor{t};
    qOrthTemp = qOrth{t};
    for i = 1:10
        name = sprintf('synth%d_%d.mat', tLen(t), i);
        [qForTemp(i, :), qOrthTemp(i, :)] = runSynthNuc(name);
    end
    qFor{t} = qForTemp;
    qOrth{t} = qOrthTemp;
    save('nuclResultsSynth.mat', 'qFor', 'qOrth')
    disp(t)
end
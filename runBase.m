% Run Greedies
clc
clear

addpath(genpath('./Greedy/'))
addpath(genpath('./baselines/'))
addpath(genpath('./models'))

global verbose
verbose = 0;
tLen = [10, 50, 100, 200];
qSp = cell(4, 1);
qOrth = cell(4, 1);
for t = 1:length(tLen)
    qSp{t} = zeros(10, 6);
    qSpTemp = qSp{t};
    parfor i = 1:10
        name = sprintf('synth%d_%d.mat', tLen(t), i);
        qSpTemp(i, :) = runSynthBase(name);
    end
    qSp{t} = qSpTemp;
    save('result/synth/sparseResultsSynth.mat', 'qSp')
    disp(t)
end
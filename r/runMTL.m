% Run MTL
clc
clear

addpath(genpath('./MALSAR1.1/'))
addpath(genpath('./Greedy/'))
addpath(genpath('./MLMTL/'))
global verbose
verbose = 0;
tLen = [10, 50, 100, 200];
qL1 = cell(4, 1);
qL21 = cell(4, 1);
qDirty = cell(4, 1);
qCMTL = cell(4, 1);
for t = 1:length(tLen)
    qL1{t} = zeros(10, 6); qL21{t} = qL1{t}; qDirty{t} = qL1{t};qCMTL{t} = qL1{t};
    qL1temp = qL1{t}; qL21temp = qL21{t}; qDirtytemp = qDirty{t};qCMTLtemp = qCMTL{t};
    parfor i = 1:10
        name = sprintf('synth%d_%d.mat', tLen(t), i);
%         [qL1temp(i, :), qL21temp(i, :), qDirtytemp(i, :), qCMTLtemp(i,:)] = runSynthMTL(name);
            [~, ~, ~, qCMTLtemp(i,:)] = runSynthMTL(name);
            display('good');
    end
    qL1{t} = qL1temp;
    qL21{t} = qL21temp;
    qDirty{t} = qDirtytemp;
    qCMTL{t} = qCMTL;
    save('result/synth/MTLResultsSynth.mat', 'qL1', 'qL21', 'qDirty')
    save('result/synth/CMTLResultsSynth.mat','qCMTL');
end
% run Tucker decomposition 
clc;
clear;

addpath(genpath('.'));
global verbose;
verbose = 1;
tLen = [10, 50, 100, 200];
qTucker = cell(4,1);
for t = 1:length(tLen)
    qTucker{t} = zeros(10, 6); 
    parfor i = 1:10
        name = sprintf('synth%d_%d.mat', tLen(t), i);
%         [qL1temp(i, :), qL21temp(i, :), qDirtytemp(i, :), qCMTLtemp(i,:)] = runSynthMTL(name);
            [qTuckerTemp(i,:)] = runSynthTucker(name);
            display('good');
    end
    qTucker{t}= qTuckerTemp;
    save('result/synth/TuckerResultsSynth.mat', 'qTucker')
end
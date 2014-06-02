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
        [qTuckerTemp(i,:)] = runSynthTucker(name);
    end
    fprintf('t = %d\n',t);
    qTucker{t}= qTuckerTemp;
    save('result/synth/TuckerResultsSynth_ds1.mat', 'qTucker')
end
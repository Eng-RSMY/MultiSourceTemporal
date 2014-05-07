% Run Greedies

global verbose
verbose = 0;
tLen = [10, 50, 100, 200];
qFor = cell(4, 1);
qOrth = cell(4, 1);
for t = 1:length(tLen)
    qFor{t} = zeros(10, 6);
    qOrth{t} = qFor{t};
    parfor i = 1:10
        name = sprintf('synth%d_%d.mat', tLen(t), i);
        [qForTemp(i, :), qOrthTemp(i, :)] = runSynthGreedy(name);  
    end
   
    qFor{t} = qForTemp;
    qOrth{t} = qOrthTemp;
    save('result/synth/greedyResultsSynth.mat', 'qFor', 'qOrth')
    disp(t)
end
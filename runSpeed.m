clc

global verbose
verbose = 0;

addpath(genpath('./'))

tTrain = 100;

nTask = [10, 31, 100, 316];

runTimes = zeros(length(nTask), 4);
for i = 1:length(nTask)
    runTimes(i, :) = runSynthSpeedup(nTask(i), tTrain);
    save('runTimes.mat', 'runTimes')
    disp(i)
end

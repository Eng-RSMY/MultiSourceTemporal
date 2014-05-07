function qFor = runSynthBase(name)
load(['./data/synth/datasets3/' name])
global verbose
nLag = 1;
[~, nLoc, nTask] = size(A);

grad = {@gradGaussian, 'Gaussian'};
lamResolution = 15; 
Lambda = logspace(-5, 2, lamResolution); 
errC = zeros(length(Lambda), 5);
% Training phase
Sol = zeros(nLoc, nLoc, nTask);
index{1} = nLag+1:size(tr_series{1}, 2);
index{2} = [];
for i = 1:length(Lambda)
    for j = 1:nTask
        Sol(:, :, j) = sparseGLARP(tr_series{j}, Lambda(i), nLag, index, grad);
    end
    errC(i, :) = testQuality3(Sol, A, v_series);
    if verbose; fprintf('Reg: %d\n', Lambda(i)); end
end
[~, ix] = min(errC(:, 4));
tic
index{1} = nLag+1:size(te_series{1}, 2);
index{2} = [];
for j = 1:nTask
    Sol(:, :, j) = sparseGLARP(te_series{j}, Lambda(ix), nLag, index, grad);
end
timeGreed = toc;
qualityGreedy = testQuality3(Sol, A, te_series);
qFor = [qualityGreedy, timeGreed];
save('result/synth/BaseResultsSynth.mat','qFor');

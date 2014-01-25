function qFor = runSynthBaseLR(name)
load(['./data/synth/datasets/' name])
global verbose
nLag = 1;
[~, nLoc, nTask] = size(A);

grad = {@gradGaussian, 'Gaussian'};
lamResolution = 10; 
% Lambda = logspace(-3, 3, lamResolution); 
TLam = logspace(-3, 3, lamResolution);
errC = zeros(length(TLam), 5);
% Training phase
Sol = zeros(nLoc, nLoc, nTask);
index{1} = nLag+1:size(tr_series{1}, 2);
index{2} = [];
for i = 1:length(TLam)
    for j = 1:nTask
        Sol(:, :, j) = lowrankGLARP(tr_series{j}, TLam(i), nLag, index, grad);
%         Sol(:, :, j) = sparseGLARP(tr_series{j}, Lambda(i), nLag, index, grad);
    end
    errC(i, :) = testQuality3(Sol, A, v_series);
    if verbose; fprintf('Reg: %d\n', TLam(i)); end
end
[~, ix] = min(errC(:, 4));
tic
index{1} = nLag+1:size(te_series{1}, 2);
index{2} = [];
for j = 1:nTask
    Sol(:, :, j) = lowrankGLARP(te_series{j}, TLam(ix), nLag, index, grad);
end
timeGreed = toc;
qualityGreedy = testQuality3(Sol, A, te_series);
qFor = [qualityGreedy, timeGreed];
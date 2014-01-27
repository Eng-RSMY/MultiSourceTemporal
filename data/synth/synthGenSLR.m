function synthGenSLR(tTrain, id)

rankTensor = 1;     % The CP rank of the tensor
% tTrain = 100;
tValid = 100;
tTest = 100;
nTask = 10;
nLoc = 20;
spRatio = floor(0.75*nLoc);   % How sparse the singular vectors should be
sig = 0.2;  % Noise Variance

A = zeros(nLoc, nLoc, nTask);
for i = 1:rankTensor
    u = zeros(nLoc, 1); v = u;
    uInd = randperm(nLoc); vInd = randperm(nLoc);
    u(uInd(1:spRatio)) = 1; v(vInd(1:spRatio)) = 1;
    u = 0.9*u/norm(u); v = v/norm(v);
    AA = u*v';
    w = 0.9 + 0.1*rand(nTask, 1);
    for j = 1:nTask
        index = randperm(nLoc^2);
        index(nLoc+1:end) = [];
        AB = zeros(nLoc);
        AB(index) = 1/nLoc;
        AB = AB + w(j)*AA;
        AB = 0.9* AB/norm(AB);
        A(:, :, j) = AB;
    end
end

% Creating the series
tr_series = cell(nTask, 1);
v_series = cell(nTask, 1);
te_series = cell(nTask, 1);
sumvals = 0;
for j = 1:nTask
    % Training
    tr_series{j} = zeros(nLoc, tTrain);
    tr_series{j}(:, 1) = randn(nLoc, 1);
    for t = 2:tTrain
        tr_series{j}(:, t) = squeeze(A(:, :, j))*tr_series{j}(:, t-1) + sig*randn(nLoc, 1);
    end
    % Validation
    v_series{j} = zeros(nLoc, tValid);
    v_series{j}(:, 1) = randn(nLoc, 1);
    for t = 2:tValid
        v_series{j}(:, t) = squeeze(A(:, :, j))*v_series{j}(:, t-1) + sig*randn(nLoc, 1);
    end
    % Testing
    te_series{j} = zeros(nLoc, tTest);
    te_series{j}(:, 1) = randn(nLoc, 1);
    for t = 2:tTest
        te_series{j}(:, t) = squeeze(A(:, :, j))*v_series{j}(:, t-1) + sig*randn(nLoc, 1);
    end
    sumvals = sumvals + norm(tr_series{j}) + norm(v_series{j}) + norm(te_series{j});
end


if sumvals > 10^4*nTask*nLoc^2
    synthGen(tTrain, id)
else
    name = sprintf('synth%d_%d', tTrain, id);
    save(['./datasets2/' name], 'tr_series', 'v_series', 'te_series', 'A')
end

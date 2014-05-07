function [qL1, qL21, qDirty , qCMTL] = runSynthMTL(name)
load(['./data/synth/datasets3/' name])
global verbose
% [~, nLoc, nTask] = size(A);
% tTrain = size(tr_series{1}, 2);
% tTest = size(te_series{1}, 2);
% tValid = size(v_series{1}, 2);
% nLag = 1;
lamResolution = 10; 
Lambda = logspace(-5, 3, lamResolution); 

errL1 = zeros(length(Lambda), 5);
errL21 = zeros(length(Lambda), 5);
errDirty = zeros(length(Lambda), 5);
errCMTL = zeros(length(Lambda), 5);

qL1 = [];
qL21 =[]'
qDirty =[];
qCMTL = [];
%% Training phase
for i = 1:length(Lambda)
%     SolL1 = MTGL( tr_series, 'Lasso', Lambda(i));
%     SolL1 = SolL1.data;
%     errL1(i, :) = testQuality3(SolL1, A, v_series);
%     
%     SolL21 = MTGL( tr_series, 'L21', Lambda(i));
%     SolL21 = SolL21.data;
%     errL21(i, :) = testQuality3(SolL21, A, v_series);
%     
%     SolDirty = MTGL( tr_series, 'Dirty', Lambda(i));
%     SolDirty = SolDirty.data;
%     errDirty(i, :) = testQuality3(SolDirty, A, v_series);
    
    SolCMTL = MTGL( tr_series, 'CMTL', Lambda(i));
    SolCMTL = SolCMTL.data;
    errCMTL(i, :) = testQuality3(SolCMTL, A, v_series);
    if verbose; fprintf('Reg: %d\n', Lambda(i)); end
end
%% Final Testing
% [~, ix] = min(errL1(:, 4));
% tic
% SolL1 = MTGL( tr_series, 'Lasso', Lambda(ix));
% timeReg = toc;
% SolL1 = SolL1.data;
% qReg = testQuality3(SolL1, A, te_series);
% qL1 = [qReg, timeReg];
% 
% [~, ix] = min(errL21(:, 4));
% tic
% SolL21 = MTGL( tr_series, 'L21', Lambda(ix));
% timeReg = toc;
% SolL21 = SolL21.data;
% qReg = testQuality3(SolL21, A, te_series);
% qL21 = [qReg, timeReg];
% 
% [~, ix] = min(errDirty(:, 4));
% tic
% SolDirty = MTGL( tr_series, 'Dirty', Lambda(ix));
% timeReg = toc;
% SolDirty = SolDirty.data;
% qReg = testQuality3(SolDirty, A, te_series);
% qDirty = [qReg,  timeReg];

[~, ix] = min(errCMTL(:, 4));
tic
SolCMTL = MTGL( tr_series, 'CMTL', Lambda(ix));
timeReg = toc;
SolCMTL = SolCMTL.data;
qReg = testQuality3(SolCMTL, A, te_series);
qCMTL = [qReg,  timeReg];
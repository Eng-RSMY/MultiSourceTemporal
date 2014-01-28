clc
clear

samples = [10, 50, 100, 200];

% for i = 1:4
i =1;
    load greedyResultsSynth.mat
    
    forward = [qFor{1}(:, i), qFor{2}(:, i), qFor{3}(:, i), qFor{4}(:, i)];
    forwardMean = mean(forward, 1);
    forwardSD = std(forward, 0, 1);
    
    orth = [qOrth{1}(:, i), qOrth{2}(:, i), qOrth{3}(:, i), qOrth{4}(:, i)];
    orthMean = mean(orth, 1);
    orthSD = std(orth, 0, 1);
    
%     load nuclResultsSynth_v0.mat
%     convex = [qFor{1}(:, i), qFor{2}(:, i), qFor{3}(:, i), qFor{4}(:, i)];
%     convexMean = mean(convex, 1);
%     convexSD = std(convex, 0, 1);
%     
%     mixture = [qOrth{1}(:, i), qOrth{2}(:, i), qOrth{3}(:, i), qOrth{4}(:, i)];
%     mixtureMean = mean(mixture, 1);
%     mixtureSD = std(mixture, 0, 1);

    %%
    load ('Synth_MLMTL_Convex');
    [T,N] = size(Qualities);
    RMSE_est = zeros(T,N);
    for t = 1:T
        for i = 1:N
            RMSE_est(t,i) =  Qualities{t,i}.RMSE_est;
        end
    end
    RMSE_est = RMSE_est';
    convexMean = mean(RMSE_est);
    convexSD = std(RMSE_est);
    tLen = [10, 50, 100, 200];


    load ('Synth_MLMTL_Mixture');
    RMSE_est = zeros(T,N);
    for t = 1:T
        for i = 1:N
            RMSE_est(t,i) =  Qualities{t,i}.RMSE_est;
        end
    end
    RMSE_est = RMSE_est';
    mixtureMean = mean(RMSE_est);
    mixtureSD = std(RMSE_est);
    
    
%%
   i =1; 
    load lrResultsSynth.mat
    lowrank = [qSp{1}(:, i), qSp{2}(:, i), qSp{3}(:, i), qSp{4}(:, i)];
    lowrankMean = mean(lowrank, 1);
    lowrankSD = std(lowrank, 0, 1);
    
    load sparseResultsSynth.mat
    sparse = [qSp{1}(:, i), qSp{2}(:, i), qSp{3}(:, i), qSp{4}(:, i)];
    sparseMean = mean(sparse, 1);
    sparseSD = std(sparse, 0, 1);
    
    load mtlResultsSynth.mat
    L1 = [qL1{1}(:, i), qL1{2}(:, i), qL1{3}(:, i), qL1{4}(:, i)];
    L1Mean = mean(L1, 1);
    L1SD = std(L1, 0, 1);
    
    L21 = [qL21{1}(:, i), qL21{2}(:, i), qL21{3}(:, i), qL21{4}(:, i)];
    L21Mean = mean(L21, 1);
    L21SD = std(L21, 0, 1);
    
    Dirty = [qDirty{1}(:, i), qDirty{2}(:, i), qDirty{3}(:, i), qDirty{4}(:, i)];
    DirtyMean = mean(Dirty, 1);
    DirtySD = std(Dirty, 0, 1);
    
    
    
    figure
    hold all
    errorbar(samples, forwardMean, forwardSD)
    errorbar(samples, orthMean, orthSD)
    errorbar(samples, convexMean, convexSD)
    errorbar(samples, mixtureMean, mixtureSD)

     
    errorbar(samples, lowrankMean, lowrankSD)
%     errorbar(samples, sparseMean, sparseSD)
    errorbar(samples, L1Mean, L1SD)
    errorbar(samples, L21Mean, L21SD)
    errorbar(samples, DirtyMean, DirtySD)
    
    legend('Forward', 'Orthogonal', 'Overlapped', 'Mixture', 'Low-rank',  'MTL: L1', 'MTL: L21', 'MTL: Dirty')
    xlabel('# of Samples')
% end
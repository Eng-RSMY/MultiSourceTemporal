clc
clear

samples = [10, 50, 100, 200];

% for i = 1:4
     i =2;
    load greedyResultsSynth.mat
    
    forward = [qFor{1}(:, i), qFor{2}(:, i), qFor{3}(:, i), qFor{4}(:, i)]/3;
    forwardMean = mean(forward, 1);
    forwardSD = std(forward, 0, 1);
    
    orth = [qOrth{1}(:, i), qOrth{2}(:, i), qOrth{3}(:, i), qOrth{4}(:, i)]/3;
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


    load lrResultsSynth.mat
    lowrank = [qSp{1}(:, i), qSp{2}(:, i), qSp{3}(:, i), qSp{4}(:, i)]/3;
    lowrankMean = mean(lowrank, 1);
    lowrankSD = std(lowrank, 0, 1);
    
    load sparseResultsSynth.mat
    sparse = [qSp{1}(:, i), qSp{2}(:, i), qSp{3}(:, i), qSp{4}(:, i)];
    sparseMean = mean(sparse, 1);
    sparseSD = std(sparse, 0, 1);
    
    load mtlResultsSynth.mat
    L1 = [qL1{1}(:, i), qL1{2}(:, i), qL1{3}(:, i), qL1{4}(:, i)]/3;
    L1Mean = mean(L1, 1);
    L1SD = std(L1, 0, 1);
    
    L21 = [qL21{1}(:, i), qL21{2}(:, i), qL21{3}(:, i), qL21{4}(:, i)]/3;
    L21Mean = mean(L21, 1);
    L21SD = std(L21, 0, 1);
    
    Dirty = [qDirty{1}(:, i), qDirty{2}(:, i), qDirty{3}(:, i), qDirty{4}(:, i)]/3;
    DirtyMean = mean(Dirty, 1);
    DirtySD = std(Dirty, 0, 1);
 
    
    %%
    load ('Synth_MLMTL_Convex');
   
    [T,N] = size(Qualities);
    RMSE_est = zeros(T,N);
    SVs1 = cell(T,N);
    for t = 1:T
        for i = 1:N
            W = Ws{t,i};
%             [RMSE_est(t,i),SVs1{t,i}] =  cal_LatentRank(W,1e-2);% Qualities{t,i}.Rank;
%                RMSE_est(t,i) =  Qualities{t,i}.RMSE;
        end
    end
    RMSE_est = RMSE_est';
    convexMean = mean(RMSE_est);
    convexSD = std(RMSE_est);
    tLen = [10, 50, 100, 200];


    load ('Synth_MLMTL_Mixture');
    RMSE_est = zeros(T,N);
    SVs2 = cell(T,1);
    for t = 1:T
        for i = 1:N
            W = Ws{t,i};
%             [RMSE_est(t,i),SVs2{t,i}] =   cal_LatentRank(W,1e-2); % Qualities{t,i}.Rank;
%             RMSE_est(t,i) =  Qualities{t,i}.RMSE;
        end
    end
    RMSE_est = RMSE_est';
    mixtureMean = mean(RMSE_est);
    mixtureSD = std(RMSE_est);
    %%
%     figure;
%     hold all;
%   
%     for t = 1:T
%         subplot(2,T,t);
%         hist(SVs1{t}); 
%         title(strcat('Sample Size: ',int2str(tLen(t))));
%         
%     end
%    
%     for t = 1:T
%         subplot(2,T,T+t);
%         hist(SVs2{t}); 
%         title(strcat('Sample Size: ',int2str(tLen(t))));
% 
%     end
%     hold off;
    
    %%
    
    
    figure
    hold all
    errorbar(samples, forwardMean, forwardSD)
    errorbar(samples, orthMean, orthSD)
    errorbar(samples, convexMean, convexSD)
    errorbar(samples, mixtureMean, mixtureSD)

     
    errorbar(samples, lowrankMean, lowrankSD)
%     errorbar(samples, sparsemean, sparsesd)
%     errorbar(samples, l1mean, l1sd)
%     errorbar(samples, l21mean, l21sd)
%     errorbar(samples, dirtymean, dirtysd)
   legend('forward', 'orthogonal', 'overlapped', 'mixture', 'low-rank')

%     legend('forward', 'orthogonal', 'overlapped', 'mixture', 'low-rank',  'mtl: l1', 'mtl: l21', 'mtl: dirty')
    xlabel('# of samples')

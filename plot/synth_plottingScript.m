clc
clear
path ='./result/final/';

samples = [10, 50, 100, 200];

% for i = 1:4
    i = 2;
    load (strcat(path,'greedyResultsSynth.mat'));
    
    forward = [qFor{1}(:, i), qFor{2}(:, i), qFor{3}(:, i), qFor{4}(:, i)];
    forwardMean = mean(forward, 1);
    forwardSD = std(forward, 0, 1);
    
    orth = [qOrth{1}(:, i), qOrth{2}(:, i), qOrth{3}(:, i), qOrth{4}(:, i)];
    orthMean = mean(orth, 1);
    orthSD = std(orth, 0, 1);
    

    
    mixture = [qOrth{1}(:, i), qOrth{2}(:, i), qOrth{3}(:, i), qOrth{4}(:, i)];
    mixtureMean = mean(mixture, 1);
    mixtureSD = std(mixture, 0, 1);

    load (strcat(path,'TuckerResultsSynth_ds1.mat'));

    tucker = [qTucker{1}(:, i), qTucker{2}(:, i), qTucker{3}(:, i), qTucker{4}(:, i)];
    tuckerMean = mean(tucker, 1);
    tuckerSD = std(tucker, 0, 1);

    load (strcat(path,'lrResultsSynth.mat'));
    lowrank = [qSp{1}(:, i), qSp{2}(:, i), qSp{3}(:, i), qSp{4}(:, i)];
    lowrankMean = mean(lowrank, 1);
    lowrankSD = std(lowrank, 0, 1);
        
    load (strcat(path,'mtlResultsSynth.mat'));
    L1 = [qL1{1}(:, i), qL1{2}(:, i), qL1{3}(:, i), qL1{4}(:, i)];
    L1Mean = mean(L1, 1);
    L1SD = std(L1, 0, 1);
    
    L21 = [qL21{1}(:, i), qL21{2}(:, i), qL21{3}(:, i), qL21{4}(:, i)];
    L21Mean = mean(L21, 1);
    L21SD = std(L21, 0, 1);
    
    Dirty = [qDirty{1}(:, i), qDirty{2}(:, i), qDirty{3}(:, i), qDirty{4}(:, i)];
    DirtyMean = mean(Dirty, 1);
    DirtySD = std(Dirty, 0, 1);
    
    load (strcat(path,'CMTLResultsSynth.mat'));
    CMTL = [qDirty{1}(:, i), qDirty{2}(:, i), qDirty{3}(:, i), qDirty{4}(:, i)];
    CMTLMean = mean(CMTL, 1);
    CMTLSD = std(CMTL, 0, 1);
 
    load (strcat(path,'CMTLResultsSynth.mat'));
    CMTL = [qDirty{1}(:, i), qDirty{2}(:, i), qDirty{3}(:, i), qDirty{4}(:, i)];
    CMTLMean = mean(CMTL, 1);
    CMTLSD = std(CMTL, 0, 1);

    
    
    %%
%     load ('Synth_MLMTL_Convex');
%    
%     [T,N] = size(Qualities);
%     RMSE_est = zeros(T,N);
%     SVs1 = cell(T,N);
%     for t = 1:T
%         for i = 1:N
%             W = Ws{t,i};
% %             [RMSE_est(t,i),SVs1{t,i}] =  cal_LatentRank(W,1e-2);% Qualities{t,i}.Rank;
%                RMSE_est(t,i) =  Qualities{t,i}.RMSE_est;
%         end
%     end
%     RMSE_est = RMSE_est';
%     convexMean = mean(RMSE_est);
%     convexSD = std(RMSE_est);
%     tLen = [10, 50, 100, 200];


    load ('Synth_MLMTL_Convex');
    [T,N] = size(Qualities);
    RMSE_est = zeros(T,N);
    SVs2 = cell(T,1);
    for t = 1:T
        for i = 1:N
            W = Ws{t,i};
%             [RMSE_est(t,i),SVs2{t,i}] =   cal_LatentRank(W,1e-2); % Qualities{t,i}.Rank;
            RMSE_est(t,i) =  Qualities{t,i}.Rank;
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
     % parameter estimation error
    
    figure
    hold all
    errorbar(samples, forwardMean, forwardSD)
    errorbar(samples, orthMean, orthSD)
    
    errorbar(samples, mixtureMean, mixtureSD)

    errorbar(samples, tuckerMean, tuckerSD) 
    errorbar(samples, lowrankMean, lowrankSD)
    errorbar(samples, L1Mean, L1SD)
    errorbar(samples, L21Mean, L21SD)
    errorbar(samples, DirtyMean, DirtySD)
    errorbar(samples, CMTLMean,CMTLSD);

    legend('Forward', 'Orthogonal', 'ADMM', 'Tucker', 'Trace',  'MTL-L1', 'MTL-L21', 'MTL-Dirty','CMTL')
    xlabel('# of samples')
    
    %% rank
        figure
    hold all
    errorbar(samples, forwardMean, forwardSD)
    errorbar(samples, orthMean, orthSD)
    
    errorbar(samples, mixtureMean, mixtureSD)

    errorbar(samples, tuckerMean/3, tuckerSD) 
    errorbar(samples, lowrankMean, lowrankSD)


    legend('Forward', 'Orthogonal', 'ADMM', 'Tucker', 'Trace')
    xlabel('# of samples')

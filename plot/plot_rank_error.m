clc
clear
path ='./result/synth/';

Ranks = [1:10]; % [errReg, rankReg, trcompReg, predReg]
i = 1 ;
load (strcat(path,'greedyResultsSynth_rk2.mat'));
tmp = load (strcat(path,'greedyResultsSynth_rk2_1.mat'));
forward = [];
for rnk = Ranks
    forward = [forward, qFor{rnk}(:, i)];
end
qFor{1}  = tmp.qFor{1};
forwardMean = mean(forward, 1);
forwardSD = std(forward, 0, 1);



orth = [];

for rnk = Ranks
    orth = [orth,qOrth{rnk}(:, i)];
end
qOrth{1}  = tmp.qOrth{1};
orthMean = mean(orth, 1);
orthSD = std(orth, 0, 1);

load (strcat(path,'nuclResultsSynth_rk2.mat'));
convex =[];
for rnk = Ranks
    convex = [convex, qFor{rnk}(:, i)];
end
convexMean = mean(convex, 1);
convexSD = std(convex, 0, 1);

mixture =[];
for rnk = Ranks
    mixture = [mixture, qOrth{rnk}(:, i)];
end
mixtureMean = mean(mixture, 1);
mixtureSD = std(mixture, 0, 1);

%%
figure
hold all
errorbar(Ranks, forwardMean, forwardSD)
errorbar(Ranks, orthMean, orthSD)
errorbar(Ranks, convexMean, convexSD)
errorbar(Ranks, mixtureMean, mixtureSD)

legend('Forward', 'Orthogonal', 'Convex', 'Mixture');
xlabel('Rank');
ylabel('Parameter Estimation Error');
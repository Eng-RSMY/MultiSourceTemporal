%  The goal is to analyze the different aspect of the tensor obtained in
%  analyzeResults.m

clc
clear

load genomeResults.mat

Sol(4) = [];
nType = length(Sol);

solution = zeros(size(Sol{1}, 1), size(Sol{1}, 2), nType);
for i = 1:nType
    solution(:, :, i) = Sol{i};
end

%% Method 1: Structure of the mean
face1 = squeeze(mean(solution, 1));
face2 = squeeze(mean(solution, 2));
face3 = squeeze(mean(solution, 3));
subplot(1, 3, 1)
S1 = svd(face1);
% stem(S1)
stairs([0; cumsum(sort(S1/sum(S1), 'descend'))])
subplot(1, 3, 2)
S2 = svd(face2);
% stem(S2)
stairs([0; cumsum(sort(S2/sum(S2), 'descend'))])
subplot(1, 3, 3)
S3 = svd(face3);
% stem(S3)
stairs([0; cumsum(sort(S3/sum(S3), 'descend'))])
%% Method 2: Mean of the individual structures
figure
subplot(1, 3, 1)
S1 = 0;
for i = 1:size(solution, 1)
    S1 = S1 + svd(squeeze(solution(i, :, :)));
end
% stem(S1/size(solution, 1))
stairs([0; cumsum(sort(S1/sum(S1), 'descend'))])
subplot(1, 3, 2)
S2 = 0;
for i = 1:size(solution, 2)
    S2 = S2 + svd(squeeze(solution(:, i, :)));
end
% stem(S2/size(solution, 2))
stairs([0;cumsum(sort(S2/sum(S2), 'descend'))])

subplot(1, 3, 3)
S3 = 0;
for i = 1:size(solution, 3)
    S3 = S3 + svd(squeeze(solution(:, :, i)));
end
% stem(S3/size(solution, 3))
stairs([0; cumsum(sort(S3/sum(S3), 'descend'))])

function [ p1,p2,p3,total ] = tensorModeRank( X )
%N_MODE_RANK Summary of this function goes here
%   X is a three-way tensor. this function analyze the structures of the
%   tensor

% face1 = flatten(X,1);
% face2 = flatten(X,2);
% face3 = flatten(X,3);

global plot;
plot = 0;

face1 = squeeze(mean(X,1));
face2 = squeeze(mean(X,2));
face3 = squeeze(mean(X,3));

S1 = svd(face1);
S2 = svd(face2);
S3 = svd(face3);

if plot
    subplot(1, 3, 1)
    % stem(S1)
    stairs([0; cumsum(sort(S1/sum(S1), 'descend'))])
    ylim([0,1]);

    subplot(1, 3, 2)
     % stem(S2)
    stairs([0; cumsum(sort(S2/sum(S2), 'descend'))])
    ylim([0,1]);
    subplot(1, 3, 3)
    % stem(S3)
    stairs([0; cumsum(sort(S3/sum(S3), 'descend'))])
    ylim([0,1]);
end

p1 = max(S1)/sum(S1);
p2 = max(S2)/sum(S2);
p3 = max(S3)/sum(S3);

total = sum([p1,p2,p2]);


end


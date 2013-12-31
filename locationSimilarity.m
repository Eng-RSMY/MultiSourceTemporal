% The goal is to find the similarity between the L1 and L2 distance and the
% geometrical distance
% close all
% clear all
% clc
% 
% load('../tminP3.mat')		% This containts the location information for the stations
% load new_s_resultTmax.mat	% This contains the Sol matrices
% 
% nLoc = size(data, 1);

[pp1, pp2] =  function locationSimilarity(Sol, Loc)
nLoc = size(Loc,1);
names = Loc;

% Here we create a nLoc x nLoc matrix of distance among the stations
% L2-distance has been used.
distance = (ones(nLoc, 1)*names(:, 2)' - names(:, 2)*ones(1, nLoc)).^2;
distance = distance + (ones(nLoc, 1)*names(:, 3)' - names(:, 3)*ones(1, nLoc)).^2;
distance = sqrt(distance);

% We create two (nLoc x nLoc) matrices that measure the distance among the parameter 
% vectors of the locations
L2dist = 0*distance;
L1dist = 0*distance;
for j = 1:nLoc
    for i = 1:length(Sol)
        M = Sol{i}*(ones(nLoc) - eye(nLoc));
        L2dist(j, :) = L2dist(j, :) + sum(abs(M - M(j, :)'*ones(1, nLoc)).^2, 2)'/nLoc;
        L1dist(j, :) = L1dist(j, :) + sum(abs(M - M(j, :)'*ones(1, nLoc)), 2)'/nLoc;
    end
end
L2dist = L2dist/length(Sol);
L1dist = L1dist/length(Sol);
L2dist = L2dist/(max(L2dist(:)));
L1dist = L1dist/(max(L1dist(:)));

% Find the correlation between geographical distance and the distance among the 
% parameters
distance = distance/(max(max(distance)));
pp2 = corrcoef([distance(:), L2dist(:)]);
pp1 = corrcoef([distance(:), L1dist(:)]);

fprintf('L1dist = %f\nL2dist = %f\n', pp1(1, 2), pp2(1, 2))
end

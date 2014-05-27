function [ K ] = sim_Haversine( locs, sigma )
%SIM_HAVERSINE Summary of this function goes here
%   Detailed explanation goes here
nLoc = size(locs);
d = [];
for i = 1:nLoc
    for j = i+1: nLoc
        d = [d ,haversine(locs(j,:), locs(i,:))];
    end
end

sigma_dist = std(d);
mean_dist = mean(d);
D = squareform(d);
K = exp(-(D-mean_dist)/sigma_dist);
end


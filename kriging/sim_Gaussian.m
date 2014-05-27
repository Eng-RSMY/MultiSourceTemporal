function [ K ] = sim_Gaussian( locs, sigma )
%SIM_GAUSSIAN Summary of this function goes here
%   Detailed explanation goes here

D = squareform(pdist(locs, 'euclidean'));
K = exp(-D/sigma);
end


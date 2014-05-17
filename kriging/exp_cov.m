function [ cov_val ] = exp_cov( geo_loc, sigma_0 , sigma_1 , theta_1, theta_2)
% EXP_COV Summary: take the longitude and latitude, calculate the
% exponential covariance
%   Detailed explanation goes here

% geo_loc = names(:,2:3);sigma_0 = 0; sigma_1=0.01; theta_1 = 10; theta_2=1;

P = size(geo_loc, 1);
cov_val = zeros (P,P);

D = squareform(pdist(geo_loc, 'euclidean'));

cov_val = sigma_0^2* eye(P) +  sigma_1^2 * exp(-D/theta_1)^theta_2;
end


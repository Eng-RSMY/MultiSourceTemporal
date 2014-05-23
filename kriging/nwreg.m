function kout = nwreg(K, locs, newloc, sigma)
% This function computes the value of the kernels in the new location
% K = (n x n)
% locs = (n x 2)
% newloc = (m x 2)
% sigma = scalar

nLoc = size(locs, 1);
nNew = size(newloc, 1);

kernel = exp(-( (locs(:, 1)*ones(1, nNew) - ones(nLoc, 1)*newloc(:, 1)').^2 + ...
    (locs(:, 2)*ones(1, nNew) - ones(nLoc, 1)*newloc(:, 2)').^2 )/sigma);
kernel = kernel./(ones(nLoc, 1)*sum(kernel, 1)); % Normalization

kout = K*kernel;


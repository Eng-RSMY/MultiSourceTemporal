function sim = euclidSim(locations, sigma)
nLoc = size(locations, 1);
sim = exp(-( (locations(:, 1)*ones(1, nLoc) - ones(nLoc, 1)*locations(:, 1)').^2 + ...
    (locations(:, 2)*ones(1, nLoc) - ones(nLoc, 1)*locations(:, 2)').^2 )/sigma);

sim = diag(sum(sim)) - sim;  % The Laplacian
end
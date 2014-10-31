% Generates training and testing time stamps
clc
clear

load yelp.mat

nLoc = size(series{1}, 1);

nMiss = 14;

N = 10;
idx_Missing = zeros(nMiss, N);

for i = 1:N
    in = randperm(nLoc);
    idx_Missing(:, i) = in(1:nMiss)';
end

save('yelp_missIdx.mat', 'idx_Missing')
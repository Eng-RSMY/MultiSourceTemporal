% Generates training and testing time stamps
clc
clear

load norm_4sq_small.mat

nLoc = size(series{1}, 1);

nMiss = 5;

N = 10;
idx_Missing = zeros(nMiss, N);

for i = 1:N
    in = randperm(nLoc);
    idx_Missing(:, i) = in(1:nMiss)';
end

save('fsq_missIdx.mat', 'idx_Missing')
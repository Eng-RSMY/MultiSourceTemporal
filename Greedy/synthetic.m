% Toy synthetic dataset
clc
clear

r = 10;
p = 20;
T = 1000;
sig = 0.2;
AA = [0.9, 0, 0, 0; 1, 0.9, 0, 0; 1, 0, 0.9, 0; 1, 0, 0, 0.9];
A = kron(eye(p/4), AA);

series = cell(r, 1);
for j = 1:r
    series{j} = zeros(p, T);
    series{j}(:, 1) = randn(p, 1);
    for t = 2:T
        series{j}(:, t) = A*series{j}(:, t-1) + sig*randn(p, 1);
    end
end

% save('synthBench.mat', 'series', 'A')
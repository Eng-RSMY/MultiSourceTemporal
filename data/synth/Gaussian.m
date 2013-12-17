p = 20;
T = 500;
AA = [0.9, 0, 0, 0; 1, 0.9, 0, 0; 1, 0, 0.9, 0; 1, 0, 0, 0.9];
A = kron(eye(p/4), AA);
series = zeros(p, T);
sig = 0.2;
series(:, 1) = sig*randn(p, 1);
for t = 2:T
    series(:, t) = A*series(:, t-1) + sig*randn(p, 1);
end

save('synthGauss.mat', 'series', 'A')
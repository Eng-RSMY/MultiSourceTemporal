function [obj, G, Gb] = gradPoisson(series, S, b, index)
T = length(index);
P = length(S);
N = size(series, 1);
mu = b*ones(1, T);
for ll = 1:P
    mu = mu + S{ll}*series(:, index-ll);
end

obj = -sum(sum(series(:, index).*mu - exp(mu)))/T/N;
Gb = -(series(:, index)-exp(mu))*ones(T, 1) /T/N;

G = cell(P, 1);
for ll = 1:P
    G{ll} = -series(:, index)*series(:, index-ll)'/T/N ...
        + exp(mu)*series(:, index-ll)'/T/N;
end
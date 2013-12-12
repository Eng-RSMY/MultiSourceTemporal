function [obj, G, Gb] = gradGumbel(series, S, b, index)
T = length(index);
P = length(S);
N = size(series, 1);
mu = b*ones(1, T);
for ll = 1:P
    mu = mu + S{ll}*series(:, index-ll);
end

obj = sum(sum( (series(:, index)-mu) + exp(-(series(:, index)-mu)) ))/T/N;
Gb = - sum(1-exp(-(series(:, index)-mu)), 2)/T/N;

G = cell(P, 1);
for ll = 1:P
    G{ll} = - (1-exp(-(series(:, index)-mu)))*series(:, index-ll)'/T/N;
end
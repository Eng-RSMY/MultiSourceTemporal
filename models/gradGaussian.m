function [obj, G, Gb] = gradGaussian(series, S, b, index)
T = length(index);
P = length(S);
N = size(series, 1);
mu = b*ones(1, T);
for ll = 1:P
    mu = mu + S{ll}*series(:, index-ll);
end

obj = norm( (series(:, index)-mu), 'fro' )^2/T/N;
Gb = -2* (series(:, index)-mu)*ones(T, 1) /T/N;

G = cell(P, 1);
for ll = 1:P
    G{ll} = -2*(series(:, index)-mu)*series(:, index-ll)'/T/N;
end
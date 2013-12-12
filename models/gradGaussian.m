function [obj, G, Gb] = gradGaussian(series, S, b)
[~, T] = size(series);
P = length(S);
mu = b*ones(1, T-P);
for ll = 1:P
    mu = mu + S{ll}*series(:, P-ll+1:T-ll);
end

obj = norm( (series(:, P+1:T)-mu), 'fro' )^2/(T-P);
Gb = -2* (series(:, P+1:T)-mu)*ones(T-P, 1) /(T-P);

G = cell(P, 1);
for ll = 1:P
    G{ll} = -2*(series(:, P+1:T)-mu)*series(:, P+1-ll:T-ll)'/(T-P);
end
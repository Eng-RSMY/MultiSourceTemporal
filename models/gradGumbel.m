function [obj, G, Gb] = gradGumbel(series, S, b)
[~, T] = size(series);
P = length(S);
mu = b*ones(1, T-P);
for ll = 1:P
    mu = mu + S{ll}*series(:, P-ll+1:T-ll);
end

obj = sum(sum( (series(:, P+1:T)-mu) + exp(-(series(:, P+1:T)-mu)) ))/(T-P);
Gb = - sum(1-exp(-(series(:, P+1:T)-mu)), 2)/(T-P);

G = cell(P, 1);
for ll = 1:P
    G{ll} = - (1-exp(-(series(:, P+1:T)-mu)))*series(:, P+1-ll:T-ll)'/(T-P);
end
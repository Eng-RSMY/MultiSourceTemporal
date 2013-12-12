function [obj G, Gb] = gradGumbelOld(series, S, b)
[N T] = size(series);
P = length(S);

obj = 0;
Gb = zeros(N, 1);
G = cell(P, 1);
for ll = 1:P
    G{ll} = zeros(N);
end

for t = P+1:T
    mu = b;
    for ll = 1:P
        mu = mu + S{ll}*series(:, t-ll);
    end
    obj = obj + sum( (series(:, t)-mu) + exp(-(series(:, t)-mu)) )/(T-P);
    
    Gb = Gb - (1-exp(-(series(:, t)-mu)))/(T-P);
    for ll = 1:P
        G{ll} = G{ll} - (1-exp(-(series(:, t)-mu)))*series(:, t-ll)'/(T-P);
    end    
end
end
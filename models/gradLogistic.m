function [obj, G, Gb] = gradLogistic(series, S, b, index)
T = length(index);
P = length(S);
epsilon = 1e-7;
N = size(series, 1);
mu = b*ones(1, T);
for ll = 1:P
    mu = mu + S{ll}*series(:, index-ll);
end
[ob, dr] = logist(mu);
ob(ob < epsilon) = epsilon;     % Numerical issues
ob(ob > 1-epsilon) = 1-epsilon;

obj = - sum(sum(  series(:, index).*log(ob) + (1-series(:, index)).*log(1-ob)  ))/T/N;
Gb = - sum( (series(:, index).*(dr./ob))  - ((1-series(:, index)).*dr./(1-ob)), 2 )/T/N;

G = cell(P, 1);
for ll = 1:P
    G{ll} = - ( (series(:, index).*(dr./ob))*series(:, index-ll)'  ...
        - ((1-series(:, index)).*dr./(1-ob))*series(:, index-ll)' )/T/N;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obj, derive] = logist(X)
obj = 1./(1 + exp(-X));
derive = obj.*(1-obj);
end
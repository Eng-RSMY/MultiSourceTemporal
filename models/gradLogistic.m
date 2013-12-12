function [obj, G, Gb] = gradLogistic(series, S, b)
[~, T] = size(series);
P = length(S);
epsilon = 1e-7;
mu = b*ones(1, T-P);
for ll = 1:P
    mu = mu + S{ll}*series(:, P-ll+1:T-ll);
end
[ob, dr] = logist(mu);
ob(ob < epsilon) = epsilon;     % Numerical issues
ob(ob > 1-epsilon) = 1-epsilon;

obj = - sum(sum(  series(:, P+1:T).*log(ob) + (1-series(:, P+1:T)).*log(1-ob)  ))/(T-P);
Gb = - sum( (series(:, P+1:T).*(dr./ob))  - ((1-series(:, P+1:T)).*dr./(1-ob)), 2 )/(T-P);

G = cell(P, 1);
for ll = 1:P
    G{ll} = - ( (series(:, P+1:T).*(dr./ob))*series(:, P+1-ll:T-ll)'  ...
        - ((1-series(:, P+1:T)).*dr./(1-ob))*series(:, P+1-ll:T-ll)' )/(T-P);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obj, derive] = logist(X)
obj = 1./(1 + exp(-X));
derive = obj.*(1-obj);
end
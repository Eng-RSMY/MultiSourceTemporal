function [err, normerr] = predictSp(series, S, b, index, fname)
nVar = size(series, 1);
nLag = size(S, 2)/nVar;
T = length(index);
mu = b*ones(1, T);
for ll = 1:nLag
    mu = mu + S{ll}*series(:, index-ll);
end
pred = linkglm(mu, fname);
err = norm(pred - series(:, index), 'fro')/T/nVar;
normerr = norm(pred - series(:, index), 'fro')/norm(series, 'fro')/T/nVar;

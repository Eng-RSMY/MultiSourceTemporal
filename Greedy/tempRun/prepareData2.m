function [Sol,out1,out2] = prepareData2(series, Iomega, mu, sim, max_iter, ep, testIndex, func)
% modified for kriging task, with both zero and nonzeros
% evaluation
nTask = length(series);
X = cell(nTask, 1);
Y = cell(nTask, 1);
for i = 1:nTask
    Q = chol(Iomega + mu * sim);
    M = (Q')\(Iomega*series{i});
    Y{i} = M';
    X{i} = Q';
end
tic
[Sol, tmp1, tmp2] = feval(func, Y, X, ep, max_iter, testIndex, series);
toc
out1 = tmp1(:,2);
out2 = tmp2(:,2);
end


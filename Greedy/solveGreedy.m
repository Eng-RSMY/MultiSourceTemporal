function [Sol, quality] = solveGreedy(Y, X, mu, Max_Iter, A, test)

global evaluate
r = length(X);
[p, n] = size(X{1});
q = size(Y{1}, 1);

Sol = zeros(q, p, r);
tempSol = cell(3, 1);
delta = zeros(3, 1);
obj = zeros(Max_Iter, 1);
quality = zeros(Max_Iter, 3);
err = zeros(Max_Iter, 2);
for ll = 1:r; obj(1) = obj(1) + norm(Y{ll}, 'fro')^2; end
for i = 1:Max_Iter-1
    [delta(1), tempSol{1}] = solveFold1(Y, X, Sol);
    [delta(2), tempSol{2}] = solveFold2(Y, X, Sol);
    [delta(3), tempSol{3}] = solveFold3(Y, X, Sol);
    [~, ix] = max(delta);
    if delta(ix)/obj(1) > mu
        Sol = Sol + tempSol{ix};
        for ll = 1:r; Y{ll} = Y{ll} - squeeze(tempSol{ix}(:, :, ll))*X{ll}; end
        obj(i+1) = obj(i) - delta(ix);
    else 
        break
    end
    if evaluate
        quality(i, :) = testQuality(Sol, A, X, Y)';
        err(i, :) = normpredict(test.Y, test.X, Sol);
    end
end
quality = [obj, quality, err];
% [obj, ERMSE, LRCp, TKCp, PRMSE, NPRMSE]
% plot(1:i, obj(1:i))
end
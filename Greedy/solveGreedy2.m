function [Sol, quality_all, quality_nonzero] = solveGreedy2(Y, X, mu, Max_Iter, A, test)
% reformat for kriging task--- Rose
global verbose
r = length(X);
[p, n] = size(X{1});
q = size(Y{1}, 1);

Sol = zeros(q, p, r);
tempSol = cell(3, 1);
delta = zeros(3, 1);
obj = zeros(Max_Iter, 1);
quality_all = zeros(Max_Iter, 5);
quality_nonzero = zeros(Max_Iter, 5);

for ll = 1:r; obj(1) = obj(1) + norm(Y{ll}, 'fro')^2; end
if verbose; fprintf('Iter #: %5d', 0); end
for i = 1:Max_Iter-1
    [delta(1), tempSol{1}] = solveFold1(Y, X, Sol);
    [delta(2), tempSol{2}] = solveFold2(Y, X, Sol);
    [delta(3), tempSol{3}] = solveFold3(Y, X, Sol);
    [~, ix] = max(delta);
%     if delta(ix)/obj(1) > mu
    Sol = Sol + tempSol{ix};
    for ll = 1:r; Y{ll} = Y{ll} - squeeze(tempSol{ix}(:, :, ll))*X{ll}; end
        obj(i+1) = obj(i) - delta(ix);
%     else 
%         break
%     end

    % The kriging case
    quality_all(i+1, 1) = testQualityK(Sol, A, test);
    quality_nonzero(i+1, 1) = testQualityR(Sol, A, test);
    
    if verbose
        fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
        fprintf('%5d ', i);
    end
end
quality_all = [obj, quality_all];
quality_nonzero = [obj, quality_nonzero];

% [obj, ERMSE, LRCp, TKCp, PRMSE, NPRMSE]
quality_all(i+1:end, :) = [];
quality_nonzero(i+1:end, :) = [];
% plot(1:i, obj(1:i))
if verbose; fprintf('\n'); end
end
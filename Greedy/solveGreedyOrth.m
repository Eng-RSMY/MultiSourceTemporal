function [Sol, quality] = solveGreedyOrth(Y, X, mu, Max_Iter, A, test)
% X and Y are cells of size nTask
% Y{i} is a matrix of size (nPred) x (nData)
% X{i} is a matrix of size (nFeature) x (nData)

global evaluate
global verbose
r = length(X);
[p, n] = size(X{1});
q = size(Y{1}, 1);

Sol = zeros(q, p, r);

tempSol = cell(3, 1);
delta = zeros(3, 1);
obj = zeros(Max_Iter, 1);
Yp = Y;
quality = zeros(Max_Iter, 5);
err = zeros(Max_Iter, 2);
if verbose; fprintf('Iter #: %5d', 0); end
for ll = 1:r; obj(1) = obj(1) + norm(Y{ll}, 'fro')^2; end
for i = 1:Max_Iter-1
    [delta(1), tempSol{1}] = solveFold1(Yp, X, Sol);
    [delta(2), tempSol{2}] = solveFold2(Yp, X, Sol);
    [delta(3), tempSol{3}] = solveFold3(Yp, X, Sol);
    [~, ix] = max(delta);
%    if delta(ix)/obj(1) > mu
        Sol = Sol + tempSol{ix};
        [Yp, Sol, obj(i+1)] = project(Y, X, Sol, i); % Do an orthogonal projection step here

        if evaluate == 1
            quality(i+1, :) = testQuality(Sol, A, test.X, test.Y)';
        elseif evaluate == 2  % The kriging case
            quality(i+1, 1) = testQualityK(Sol, A, test);
        elseif evaluate == 3
            quality(i+1, 1) = testQualityF(Sol, A, test.X, test.Y);
        end
%    end
    if verbose
        fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
        fprintf('%5d ', i);
    end
end

if verbose; fprintf('\n'); end
quality = [obj, quality];
quality(i+1:end, :) = [];
% [obj, ERMSE, LRCp, TKCp, PRMSE, NPRMSE]
% plot(1:i, obj(1:i))

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Y, Sol, obj] = project(Y, X, Sol, order)
% I choose to always make the projection in the first mode
[q, p, r] = size(Sol);
n = size(X{1}, 2);
matrix = unfld(Sol, 1);

% Setting up the matrices such that Loss = |YY - A x XX|_F^2
XX = zeros(p*r, n*r);
YY = zeros(q, n*r);
for ll = 1:r
    XX( p*(ll-1)+1:p*ll , n*(ll-1)+1:n*ll ) = X{ll};
    YY( : , n*(ll-1)+1:n*ll ) = Y{ll};
end

% Finding the bases
if order > min(size(matrix))
    order = min(size(matrix));
    [U, ~, V] = svds(matrix, order);
else
    [U, ~, V] = svds(matrix, order);
end

XXX = V'*XX;
YYY = U'*YY;
B = (YYY*XXX')/(XXX*XXX');
Sol = fld(U*B*V', 1, r);
obj = 0;
for ll = 1:r; 
    Y{ll} = Y{ll} - squeeze(Sol(:, :, ll))*X{ll}; 
    obj = obj + norm(Y{ll}, 'fro')^2;
end
end

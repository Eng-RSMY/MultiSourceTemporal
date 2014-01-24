function [Sol, quality] = solveGreedyOrth(Y, X, mu, Max_Iter, A, test) % A, test)
% X and Y are cells of size nTask
% Y{i} is a matrix of size (nPred) x (nData)
% X{i} is a matrix of size (nFeature) x (nData)

global evaluate
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
for ll = 1:r; obj(1) = obj(1) + norm(Y{ll}, 'fro')^2; end
for i = 1:Max_Iter-1
    [delta(1), tempSol{1}] = solveFold1(Yp, X, Sol);
    [delta(2), tempSol{2}] = solveFold2(Yp, X, Sol);
    [delta(3), tempSol{3}] = solveFold3(Yp, X, Sol);
    [~, ix] = max(delta);
    if delta(ix)/obj(1) > mu
        Sol = Sol + tempSol{ix};
        [Yp, Sol, obj(i+1)] = project(Y, X, Sol, i); % Do an orthogonal projection step here

        if evaluate
            quality(i+1, :) = testQuality(Sol, A, X, Y)';
%             if ~isempty(test.X)
%                 err(i+1, :) = normpredict(test.Y, test.X, Sol); 
%             end
        end
    end
end
quality = [obj, quality, err];
% [obj, ERMSE, LRCp, TKCp, PRMSE, NPRMSE]
% plot(1:i, obj(1:i))

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Y, Sol, obj] = project(Y, X, Sol, order)
global verbose
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
    [U, B, V] = svds(matrix, order);
else
    [U, B, V] = svds(matrix, order);
end

Max_iter = 100;
objs = zeros(1, Max_iter);
delta = 1e-5;
t = 1;
YB = B;

if verbose; fprintf('Iter #: %5d', 0); end
for i = 1:Max_iter
    objs(i) = norm(YY - (U*YB*V')*XX, 'fro')^2;
    G = - U'*((YY - (U*YB*V')*XX)*XX')*V;
    
    B_new = YB - delta*G;
    
    t_new = (1+sqrt(1+4*t^2))/2;
     YB = B_new + ((t-1)/t_new)*(B_new - B); 
    
    % Variable updates
    B = B_new;
    t = t_new;
    if verbose
        fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
        fprintf('%5d ', i);
    end
end
if verbose
    fprintf('\n')
end

Sol = fld(U*B*V', 1, r);
for ll = 1:r; 
    Y{ll} = Y{ll} - squeeze(Sol(:, :, ll))*X{ll}; 
end
obj = objs(Max_iter);
end
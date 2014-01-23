function [Sol, quality, err] = solveGreedyOrth(Y, X, mu, Max_Iter, A, test) % A, test)
% X and Y are cells of size nTask
% Y{i} is a matrix of size (nPred) x (nData)
% X{i} is a matrix of size (nFeature) x (nData)

global evaluate
r = length(X);
[p, n] = size(X{1});
q = size(Y{1}, 1);

Sol = zeros(p, q, r);

tempSol = cell(3, 1);
delta = zeros(3, 1);
obj = zeros(Max_Iter, 1);
Yp = Y;
quality = zeros(Max_Iter, 3);
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
            quality(i, :) = testQuality(Sol, A)';
            err(i, :) = normpredict(test.Y, test.X, Sol);
        end
    end
end

% plot(1:i, obj(1:i))

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Y, Sol, obj] = project(Y, X, Sol, order)
global verbose
% I choose to always make the projection in the first mode
[p, q, r] = size(Sol);
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
    Y{ll} = Y{ll} - squeeze(Sol(:, :, ll))'*X{ll}; 
end
obj = objs(Max_iter);
end
%% Rank-1 Greedy Steps
% The goal of the following functions is to (1) Find the optimal rank-1
% direction in the given mode and (2) Report the amount of decrease in the
% objective function
function [delta, Sol] = solveFold1(Y, X, Sol)
[p, q, r] = size(Sol);
n = size(X{1}, 2);
XX = zeros(p*r, n*r);
YY = zeros(q, n*r);
for ll = 1:r
    XX( p*(ll-1)+1:p*ll , n*(ll-1)+1:n*ll ) = X{ll};
    YY( : , n*(ll-1)+1:n*ll ) = Y{ll};
end
Q = XX*(YY'*YY)*(XX');
P = XX*XX';
[~, lamU] = approxEV(YY'*YY, 1e-4);
[v, ~] = approxEV(Q-lamU*P, 1e-4);
u = (YY*XX'*v)/(v'*P*v);
SS = u*v';
Sol = fld(SS, 1, r);

delta = 0;
for ll = 1:r
    delta = delta + norm(Y{ll}, 'fro') - norm(Y{ll} - squeeze(Sol(:, :, ll))'*X{ll}, 'fro');
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [delta, Sol] = solveFold2(Y, X, Sol)
[p, q, r] = size(Sol);
P = cell(r, 1);
Q = P;
% Create the Q, P matrices
for ll = 1:r
    P{ll} = X{ll}*X{ll}';
    Q{ll} = X{ll}*(Y{ll}'*Y{ll})*(X{ll}');
end

% Computing the solution
Max_Iter = 100;
obj = zeros(Max_Iter, 1);
u = ones(p, 1);
step = 1e-4;
for i = 1:Max_Iter
    [obj(i), G] = findGrad2(Q, P, u);
    u = u + step * G;
end

v = zeros(q*r, 1);
for ll = 1:r
    v(q*(ll-1)+1:q*ll) = (Y{ll}*X{ll}'*u)/(u'*P{ll}*u);
end
SS = u*v';
Sol = fld(SS, 2, r);

% Computing delta
delta = 0;
for ll = 1:r
    delta = delta + norm(Y{ll}, 'fro') - norm(Y{ll} - squeeze(Sol(:, :, ll))'*X{ll}, 'fro');
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [delta, Sol] = solveFold3(Y, X, Sol)
[p, q, r] = size(Sol);
Max_Iter = 100;
obj = zeros(Max_Iter, 1);
A = ones(q, p);
step = 1e-3;
for i = 1:Max_Iter
    [obj(i), G] = findGrad3(Y, X, A);
    A = A + step * G;
end

u = zeros(r, 1);
for i = 1:r
    u(i) = trace(A*X{i}*Y{i}')/norm(A*X{i}, 'fro')^2;
end

SS = u*reshape(A', 1, p*q); %%%
Sol = fld(SS, 3, q);

% Computing delta
delta = 0;
for ll = 1:r
    delta = delta + norm(Y{ll}, 'fro') - norm(Y{ll} - squeeze(Sol(:, :, ll))'*X{ll}, 'fro');
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obj, grad] = findGrad2(Q, P, v)
obj = 0;
grad = 0*v;
for i = 1:length(Q)
    temp = v'*Q{i}*v/(v'*P{i}*v);
    obj = obj + temp;
    grad = grad + 2*(Q{i}-P{i}*temp)*v/(v'*P{i}*v);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obj, G] = findGrad3( Y, X, A )
obj = 0;
G = 0*A;
for i = 1:length(Y)
    m = norm(A*X{i}, 'fro')^2;
    tr = trace(A*X{i}*Y{i}');
    obj = obj + tr^2/m;
    mp = 2*tr*(Y{i}*X{i}');
    G = G + mp/m - 2*A*(X{i}*X{i}')*(tr^2)/(m^2);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function quality = testQuality(Sol, A)

quality = [0;0;0];
for i = 1:size(Sol, 3)
    quality(1) = quality(1) + norm(A - squeeze(Sol(:, :, i))', 'fro')^2;
end
quality(1) = sqrt(quality(1)/size(Sol, 3))/norm(A, 'fro');

quality(2) = quality(2) + rank(unfld(Sol, 1));
quality(2) = quality(2) + rank(unfld(Sol, 2));
quality(2) = quality(2) + rank(unfld(Sol, 3));

% quality(3) = TRComplexity(Sol);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function err = normpredict(Y, X, Sol)
[~, ~, r] = size(Sol);
err = [0, 0];
for ll = 1:r
    err(1) = err(1) + norm(Y{ll} - squeeze(Sol(:, :, ll))'*X{ll}, 'fro')^2;
    err(2) = err(1)/mean(Y{ll}(:).^2);
end
err(1) = err(1)/size(Y{1}, 2);
err = sqrt(err/r);
end
function Sol = solveGreedy(Y, X, mu)

r = length(X);
[p, n] = size(X{1});
q = size(Y{1}, 1);

Sol = zeros(p, q, r);
tempSol = cell(3, 1);
delta = zeros(3, 1);
obj = zeros(Max_Iter, 1);
for i = 1:Max_Iter-1
    [delta(1), tempSol{1}] = solveFold1(Y, X, Sol);
    [delta(2), tempSol{2}] = solveFold2(Y, X, Sol);
    [delta(3), tempSol{3}] = solveFold3(Y, X, Sol);
    [~, ix] = max(delta);
    if delta(ix) > mu
        Sol = Sol + tempSol{ix};
        obj(i+1) = obj(i) - delta(ix);
    end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rank-1 Greedy Steps
% The goal of the following functions is to (1) Find the optimal rank-1
% direction in the given mode and (2) Report the amount of decrease in the
% objective function
function [delta, Sol] = solveFold1(Y, X, Sol)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [delta, Sol] = solveFold2(Y, X, Sol)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [delta, Sol] = solveFold3(Y, X, Sol)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Solout] = coreg(series, TLam, lambda, nLag, index)
global verbose
nType = length(series);
nVar = size(series{1}, 1);
% The solution will be (nV x nT) x (nV x nL)
p = nVar*nType;
q = nVar*nLag;
Sol = zeros(p + q); 
Cf = 0.5;
ep = 0.01;
MaxIter = ceil(4*Cf/ep);
% TLam = 3; % 0.3
obj = zeros(MaxIter, 1);
if verbose; fprintf('Iter #: %5d', 0); end
for i = 1:MaxIter
    [obj(i), G] = gradCoReg(series, TLam*Sol(1:p, p+1:p+q), lambda, index{1});
    
    G2 = TLam*[zeros(p, q), G; G', zeros(q, p)];
    v = approxEV(-G2, Cf/(i^2));
    Sol = Sol + (v*v' - Sol)/i;
    
    if verbose;
        fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
        fprintf('%5d ', i);
    end
end
Sol = Sol(1:p, p+1:p+q) * TLam;
if verbose; fprintf('\n');
figure; plot(obj); end

% Output Formatting
Solout = cell(nType, 1);
for i = 1:nType
    Solout{i} = Sol(nVar*(i-1)+1:nVar*i, :);
end

end
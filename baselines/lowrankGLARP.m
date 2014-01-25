function [Solm, err, normerr] = lowrankGLARP(series, TLam, nLag, index, grad)
global verbose
nVar = size(series, 1); % location
% The solution will be (nV x nT) x (nV x nL)
p = nVar;
q = nVar*nLag;
Sol = zeros(p + q); 
Cf = 0.5;
ep = 0.01;
MaxIter = ceil(4*Cf/ep);
% TLam = 3; % 0.3
%% Low-rank part
obj = zeros(MaxIter, 1);
b = zeros(p, 1);
if verbose; fprintf('Iter #: %5d', 0); end
for i = 1:MaxIter
    [obj(i), G] = gradLow(series, TLam*Sol(1:p, p+1:p+q), b, index{1}, grad{1});
    
    G2 = TLam*[zeros(p, p), G; G', zeros(q, q)];
    v = approxEV(-G2, Cf/(i^2));
    Sol = lineSearch(Sol, v, series, TLam, index{1}, p, q, grad{1}, b);
%     Sol = Sol + (v*v' - Sol)/i;
    
    if verbose;
        fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
        fprintf('%5d ', i);
    end
end
Sol = Sol(1:p, p+1:p+q) * TLam;
if verbose; fprintf('\n');
figure; plot(obj); end

Solm = cell(nLag, 1);
for ll = 1:nLag
    Solm{ll} = Sol(:, nVar*(ll-1)+1:nVar*ll);
end
[err, normerr] = predictSp(series, Solm, b, index{2}, grad{2});
Solm = Solm{1}; %%%%%%%%%%%%%%%%%%%%%%%
end
%% The gradient function
function [obj, G] = gradLow(series, Sol, b, index, grad)
[nVar, tm] = size(Sol);
nLag = tm/nVar;

Solm = cell(nLag, 1);
for ll = 1:nLag
    Solm{ll} = Sol(:, nVar*(ll-1)+1:nVar*ll);
end
[obj, Gm] = feval(grad, series, Solm, b, index);

G = 0*Sol;
for ll = 1:nLag
    G(:, nVar*(ll-1)+1:nVar*ll) = Gm{ll};
end

end
%% Line search
function Sol = lineSearch(Sol, v, series, TLam, index, p, q, grad, b)
Solp = v*v';
dL = 0;
Sol2 = Sol + dL*Solp;
objL = gradLow(series, TLam*Sol2(1:p, p+1:p+q), b, index, grad);
dU = 1;
Sol2 = Sol + dU*Solp;
objU = gradLow(series, TLam*Sol2(1:p, p+1:p+q), b, index, grad);
while abs(objL - objU) > abs(objU)*0.01
    dM = (dL + dU)/2;
    Sol2 = Sol + dM*Solp;
    objM = gradLow(series, TLam*Sol2(1:p, p+1:p+q), b, index, grad);
    if objM < objL
        dL = dM;
        objL = objM;
    else
        dU = dM;
        objU = objM;
    end
    
end
if ~exist('dM', 'var')
    dM = dL;
end
Sol = Sol + dM*Solp;
end
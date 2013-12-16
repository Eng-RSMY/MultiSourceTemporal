function [Solout, err, normerr] = coreg(series, TLam, lambda, nLag, index)
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
%% Low-rank part
obj = zeros(MaxIter, 1);
if verbose; fprintf('Iter #: %5d', 0); end
for i = 1:MaxIter
    [obj(i), G] = gradCoReg(series, TLam*Sol(1:p, p+1:p+q), lambda(1), index{1});
    
    G2 = TLam*[zeros(p, p), G; G', zeros(q, q)];
    v = approxEV(-G2, Cf/(i^2));
    Sol = lineSearch(Sol, v, series, TLam, lambda(1), index{1}, p, q);
%     Sol = Sol + (v*v' - Sol)/i;
    
    if verbose;
        fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
        fprintf('%5d ', i);
    end
end
Sol = Sol(1:p, p+1:p+q) * TLam;
if verbose; fprintf('\n');
figure; plot(obj); end

%% Sparse part
L = Sol;
obj = zeros(MaxIter, 1);
S = 0*L;
b = zeros(nVar*nType, 1);
Yb = b;
YS = S;
t = 1;
delta = 2e-2;
MaxIter = 500;
if verbose; fprintf('Iter #: %5d', 0); end
for i = 1:MaxIter
    [obj(i), G, Gb] = gradCoRegS(series, YS+L, Yb, index{1});
    b_new = Yb - delta*Gb;
    S_new = YS - delta*G;
    S_new = (abs(S_new) > lambda(2)).*(abs(S_new)-lambda(2)).*sign(S_new);
    
    t_new = (1+sqrt(1+4*t^2))/2;
    YS = S_new + ((t-1)/t_new)*(S_new - S);
    Yb = b_new + ((t-1)/t_new)*(b_new - b);
    S = S_new;
    b = b_new;
    t = t_new;
    
    if verbose;
        fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
        fprintf('%5d ', i);
    end
end
if verbose; fprintf('\n');
figure; plot(obj); end
%% Prediction
[err, normerr] = prediction(series, S+L, b, index{2});
% Output Formatting
Solout = cell(nType, 1);
for i = 1:nType
    Solout{i} = Sol(nVar*(i-1)+1:nVar*i, :);
end

end

%% Line search for better stability
function Sol = lineSearch(Sol, v, series, TLam, lambda, index, p, q)
Solp = v*v';
dL = 0;
Sol2 = Sol + dL*Solp;
objL = gradCoReg(series, TLam*Sol2(1:p, p+1:p+q), lambda, index);
dU = 1;
Sol2 = Sol + dU*Solp;
objU = gradCoReg(series, TLam*Sol2(1:p, p+1:p+q), lambda, index);
while abs(objL - objU) > abs(objU)*0.01
    dM = (dL + dU)/2;
    Sol2 = Sol + dM*Solp;
    objM = gradCoReg(series, TLam*Sol2(1:p, p+1:p+q), lambda, index);
    if objM < objL
        dL = dM;
        objL = objM;
    else
        dU = dM;
        objU = objM;
    end
    
end
Sol = Sol + dM*Solp;
end
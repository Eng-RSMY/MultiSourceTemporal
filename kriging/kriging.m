function [Solout, err, normerr] = kriging(series, loc, lambda, nLag, index)
%KRIGING Summary of this function goes here:
%   Detailed explanation goes here

global verbose
nType = length(series);
nVar = size(series{1}, 1); % location
% The solution will be (nV x nT) x (nV x nL)
p = nVar*nType;
q = nVar*nLag;

Cf = 0.5;
ep = 0.01;
MaxIter = ceil(2*Cf/ep);
delta = 2e-6;
% TLam = 3; % 0.3


%% kriging neighbourhood


obj = zeros(MaxIter, 1);
YA = zeros(p, q); 
Yb = zeros(nVar*nType, 1);
if verbose; fprintf('Iter #: %5d', 0); end

dist = zeros(nVar);
for l = 1:nVar
    for ll = 1:nVar
        dist(l,ll) = norm(loc(l,2:3)-loc(ll,2:3));
    end
end

for i = 1:MaxIter
    [obj(i), G, Gb] = gradKriging(series, dist, YA , Yb, index{1});
    b_new = Yb - delta*Gb;
    A_new = YA - delta*G;
    A_new = (abs(A_new) > lambda(2)).*(abs(A_new)-lambda(2)).*sign(A_new);
    
    t_new = (1+sqrt(1+4*t^2))/2;
    YA = A_new + ((t-1)/t_new)*(A_new - S);
    Yb = b_new + ((t-1)/t_new)*(b_new - b);
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
[err, normerr] = prediction(series, YA, b, index{2});
% Output Formatting
Solout = cell(nType, 1);
for i = 1:nType
    Solout{i} = YA(nVar*(i-1)+1:nVar*i, :);
end
end


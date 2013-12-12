function [err] = nuclowrank(Y, X, uu, vv, TLam)
global verbose
N = size(X, 1);
Sol = zeros(2*N); % Because last time we have multiplied it
Cf = 0.5;
ep = 0.01;
MaxIter = ceil(4*Cf/ep);
% TLam = 3; % 0.3
obj = zeros(MaxIter, 1);
if verbose; fprintf('Iter #: %5d', 0); end
for i = 1:MaxIter
    [obj(i), G] = gradGaussian(Y, X, TLam*Sol(1:N, N+1:2*N));
    
    G2 = TLam*[zeros(N), G; G', zeros(N)];
    v = approxEV(-G2, Cf/(i^2));
    Sol = Sol + (v*v' - Sol)/i;
    
    if verbose;
        fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
        fprintf('%5d ', i);
    end
end
Sol = Sol * TLam;
if verbose; fprintf('\n');
figure; plot(obj); end

err = norm(Sol(1:N, N+1:2*N) - uu*vv', 'fro')/norm(uu*vv', 'fro');
% obj = norm(Y - (Sol(1:N, N+1:2*N))*X, 'fro')/norm(Y, 'fro');
% obj2 = norm(Y - (uu*vv')*X, 'fro')/norm(Y, 'fro');
% disp(obj2/obj)
end
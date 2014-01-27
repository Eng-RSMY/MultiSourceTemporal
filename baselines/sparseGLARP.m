function [S, err, normerr] = sparseGLARP(series, lambda, nLag, index, grad)
global verbose
global draw
n = size(series, 1);

if length(grad) == 3
    lrSol = grad{3};
else
    lrSol = zeros(n);
end

delta = 10;

MaxIter = 200;

% Initialize the parameters
S = cell(nLag, 1);
for i = 1:nLag
    S{i} = zeros(n);
end
b = zeros(n, 1);
Yb = b;
YS = S;
S_new = S;
t = 1;
obj = zeros(MaxIter, 1);
if verbose; fprintf('Iter #: %5d', 0); end
for i = 1:MaxIter
    tmp = YS;   %% Not good.  Fix this part
    tmp{1} = tmp{1} + lrSol;
    [obj(i), G, Gb] = feval(grad{1}, series, tmp, Yb, index{1});
    
    t_new = (1+sqrt(1+4*t^2))/2;
    b_new = Yb - delta*Gb;
    Yb = b_new + ((t-1)/t_new)*(b_new - b);
    b = b_new;
    
    for ll = 1:nLag
        S_new{ll} = YS{ll} - delta*G{ll};
        S_new{ll} = (abs(S_new{ll}) > lambda).*(abs(S_new{ll})-lambda).*sign(S_new{ll});
        YS{ll} = S_new{ll} + ((t-1)/t_new)*(S_new{ll} - S{ll});
        S{ll} = S_new{ll};
    end
    
    t = t_new;
    
    if verbose;
        fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
        fprintf('%5d ', i);
    end
    if (obj(i) > 10*obj(1)) || (isnan(obj(i)))
        for ll = 1:nLag; YS{ll} = zeros(n);  end
        Yb = 0*b;
        delta = delta/10;
        MaxIter = MaxIter + i;
    end
end
if verbose; fprintf('\n'); end

if draw figure; plot(obj); end

[err, normerr] = predictSp(series, S, b, index{2}, grad{2});
S = S{1};   %% Very temporarily %%%%%%
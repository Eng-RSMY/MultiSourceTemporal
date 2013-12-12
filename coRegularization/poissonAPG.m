function [err, normerr, AIC, BIC, AUC] = poissonAPG(count, Lambda_S, index, in, Strue, L)
% Objective:	This function computes the temporal dependency matrix among multiple count data 
%					and evaluates the quality of estimation.
% Algorithms:	Accelerated Proximal Gradient + Poisson distribution
% Input:	
%	count:		The time series, an n x T matrix
%	Lambda_S:	The lasso penalization parameter
%	L:			Number of lags
% 	index:		Used for cross-validation purposes, it is a cell with nCV elements.
%					The cell elements are mutually exclusive sets of timestamps
%					between [P+1:T]. 
%`	in:				The index set which is set out for evaluation.
%					The rest of the  time stamps \in [P+1:T] are used for evaluation.
%	Strue:		The ground truth temporal dependency matrix
% Output:	
% 	err:		The absoulute RMS prediction error
%	normerr:	The absoulute RMS prediction error normalized by the mean of the data
%	AIC:		The Akaike information criterion
% 	BIC:		The Bayesian information criterion
% 	AUC:		The area under the ROC curve

[N, T] = size(count);
% L = 1;
S = cell(1, L);
for i = 1:L
    S{i} = zeros(N);
end
b = zeros(N, 1);
YS = S;
S_new = S;
Yb = b;

indexes = catCell(index, in, length(index));

% %%%% Temporary for TE
% load tetwitterNames.mat
% adj = SS > 0;
% Lambda_S = 1e-9;

% Lambda_S = 0.000065;
% aLam = 0.1;
Ld = 0; %0.01;
L2 = 0;

delta = 1e-5;
Max_iter = 250;
objs = zeros(1, Max_iter);
t = 1;
fprintf('Iter #: %5d', 0);
for i = 1:Max_iter
    [objs(i), G, Gb] = findGrad(count, YS, Yb, indexes);
    
    b_new = Yb - delta * Gb;
    for ll = 1:L
        S_new{ll} = YS{ll} - delta * G{ll} - Ld*YS{ll}.*eye(N) - L2*YS{ll}; %adj.*: Decreasing the diagonal coefficient
        S_new{ll} = (abs(S_new{ll}) > Lambda_S).*(abs(S_new{ll})-Lambda_S).*sign(S_new{ll}); % Sparse Projection Step
    end
    
    t_new = (1+sqrt(1+4*t^2))/2;
    for ll = 1:L; YS{ll} = S_new{ll} + ((t-1)/t_new)*(S_new{ll} - S{ll}); end
    Yb = b_new + ((t-1)/t_new)*(b_new - b);  
    
    % Variable updates
    for ll = 1:L; S{ll} = S_new{ll}; end
    b = b_new;
    t = t_new;
    fprintf('%c%c%c%c%c%c', 8,8,8,8,8,8);
    fprintf('%5d ', i);
end

plot(objs)
% save(name, 'S')
th = 0.01;
nnZ = 0;
for i = 1:L
    nnZ = nnZ + sum(sum(abs(S{i}) > th));
end
AIC = objs(Max_iter) + nnZ;
BIC = 2*objs(Max_iter) + nnZ*log(length(indexes)*N);
SS = zeros(N);
for ll = 1:5; SS = SS+ abs(S{ll}).*(ones(N)-eye(N)); end
St = Strue.*(ones(N)-eye(N));
[~, ~, ~, AUC] = perfcurve(abs(St(:)), abs(SS(:)), max(abs(St(:))));
% disp(AUC)

err = 0;
tsMean = mean(mean(count(:, index{in})));
for t = index{in}
    arg = b;
    for i = 1:L
        arg = arg + S{i}*count(:, t-i);
    end
    err = err + norm(exp(arg) - count(:, t))^2;
end
err = sqrt(err)/N/length(index{in});
normerr = err/tsMean;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obj, G, Gb] = findGrad(count, S, b, indexes)
[N, T] = size(count);
L = length(S);
G = cell(1, L);
for ll = 1:L
   G{ll} = zeros(N); 
end
Gb = zeros(N, 1);
obj = 0;

for t = indexes
    lambda = b;
    for ll = 1:L
        lambda = lambda + S{ll}*count(:, t-ll);
    end
    obj = obj - sum(count(:, t).*lambda - exp(lambda));
    Gb = Gb - count(:, t) + exp(lambda);
    for ll = 1:L
        G{ll} = G{ll} - count(:, t)*count(:, t-ll)';
        G{ll} = G{ll} + exp(lambda)*count(:, t-ll)';
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function indexes = catCell(index, i, nCV)
indexes = [];
for k = 1:nCV
    if k == i; continue; end
    indexes = [indexes index{k}];
end
end
% clear all
clc
close all

addpath(genpath('./'))

series = cell(3, 1);
load temp.mat
obs = obs - ones(size(obs, 1), 1)*mean(obs, 1);
obs = obs./(ones(size(obs, 1), 1)*std(obs, 0, 1));
series{1} = obs';
load wind.mat
obs = obs - ones(size(obs, 1), 1)*mean(obs, 1);
obs = obs./(ones(size(obs, 1), 1)*std(obs, 0, 1));
series{2} = obs';
load rain.mat
series{3} = (obs > 0.01)'*1.0;
clear obs pars  % Housekeeping


global verbose
verbose = 1;

%%
TLam = 100;
lambda = [1, 1e-5];
nLag = 5;
T = size(series{1}, 2);
Ttest = 10;
index{1} = nLag+1:T-Ttest;
index{2} = T-Ttest+1:T;
%%

[Sol, err, normerr] = coreg(series, TLam, lambda, nLag, index);

%%
load location.mat
% [Sol2, err2, normerr2] = kriging(series, loc, lambda, nLag, index);

lambdas = [1, 0.1, 0.01];
sols = cell(1,3);
errors = cell(1,3);
for lambda = lambdas
    [sol, error] = pred_groupLasso(series, nLag, lambda,index);
    if verbose
        fprintf('lambda: %d', lambda);
        disp(error);
    end
    sols = [sols,{sol}]; errors = [sols,{error}];
    errors = [errors,{error}];
    
end

%%
lambdas = [1,0.1,0.01];
grad = {@gradGaussian, 'Gaussian'};
grad = {@gradGumbel, 'Gumbel'};

for lamba =  lambdas

    [S, err, normerr] = sparseGLARP(series{3}, lambda(2), nLag, index, grad);

end


function out = linkglm(mu, model)
% The link function for the models
switch model
    case 'Gaussian'
        out = mu;
    case 'Gumbel'
        out = mu;% - psi(1); % I have no idea why this doesn't work.
    case 'Logistic'
        out  = (1./(1 + exp(-mu)) > 0.5)*1.0;
    case 'Poisson'
        out = exp(mu);
    otherwise
        error('Model doesn''t exist')
end
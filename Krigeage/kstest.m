function [d, prob] = kstest (data) 

%	   [d, prob] = kstest (data) 
%
%	KOLMOGOROV-SMIRNOV ONE SAMPLE TEST 
%	USING STANDARD NORMAL DISTRIBUTION
%
% Function based on the ksone.f Fortran Numerical Recipes routine.
% The ksone.f subroutine has been modified to be linked with the 
% matlab environment through ksoneg.f.
%
% data: variable samples
% d:    K-S statistique D corresponding to the maximum difference
%	between the sample distribution and the normat distribution
% prob: significance level of d.  Small values of prob show that the 
%	cumulative sample distribution is significantly different 
% 	from the normal one.
%
% Critical values of d are given in TABLE B of 
% Legengre, L. et Legendre, P. (1984) Écologie numérique, Presse de 
%	l'Université du Québec, Canada, Tome I: 260 p., Tome II: 335 p.
%
% To see what the sample ditribution looks like: hist(data);
%
% C. Lafleur 16/08/96

% Standardisation of the sampled variable (data)

  x = (data - mean(data)) / std(data);

% Sort data by ascending order

  y = sort(x);

% Calculation of the cumulative normal distribution corresponding to y

  l = length(y);
  k = 1 / sqrt(2*pi);

  for i = 1:l
    xx = (-10:0.01:y(i));
    yy  = exp(-(xx.^2)/2);
    t(i) = k .* trapz(xx,yy);
  end

% Kolmogorov-Smirnov Test

  [d, prob] = ksone (y(:),l,t(:));
  

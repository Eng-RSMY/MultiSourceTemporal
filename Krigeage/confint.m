function [k2,k1] = confint (g,m,S2)

%	[k2,k1] = confint (g,m,S2)
%
%  Confidence intervals for the structure function
%
% 	CONF {k2 <= variance <= k1}	(1)
%
% The structure function is a measure of the variance of a given 
% variable as a function of distance.  The estimation of the 
% confidence intervals in such a case is given by (1).
% 
% 	k1 = (n-1) * S^2 / c1
%	k2 = (n-1) * S^2 / c2		(2)
% 
% where n   = sample size = m+1
%	m   = number of degrees of freedom
%	S^2 = variance of the sample
%	c1  and c2 are determined by the solution to the equations
%
%	F(c1) = (1-g) /2
%	F(c2) = (1+g) /2		(3)
%
% where g = confidence level (95%, 99% or the like)
%
% Solutions are obtained by function 'chitable' (ftp m-file).
%
% ref: Kreyszig, E. (1988) Advanced Engineering Mathematics, sixth edition,
%		 John Wiley & Sons, New york, p. 1252.
%

% Chi-square distribution
  
  Fc1 = (1-g) /2;
  Fc2 = (1+g) /2;

% Solutions for c1 and c2

  c1 = chitable(Fc1,m);
  c2 = chitable(Fc2,m);

% Solution for k1 and k2

  if c1 ~= 0
	k1 = m * S2 /c1;
  else
	k1 = S2;
  end
 
  if c2 ~= 0
	k2 = m * S2 /c2;
  else
	k2 = S2;
  end	 
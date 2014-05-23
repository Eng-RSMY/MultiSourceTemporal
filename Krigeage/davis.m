function [Zp,Sp] = davis(data,x0,model,a,b,c,A)

%	[Zp,Sp] = davis(data,x0,model,a,b,c)
%
% Punctual Kriging: Davis' method
%
% ref: Davis, J.C. (1986) Statistics and Data Analysis in Geology,
%	  second edition, John Wiley & Sons, New York, pp 383:386.
%
% 1-Weight equation
% 
% 	A * X = Y
% 
%   where A = gamma(h) matrix  -> [nxn]
%	  X = weight vector    -> [nx1]
%	  Y = gamma(hp) matrix -> [nx1]
%
% 2-Solution: Gauss-Jordan elimination method
%
%	X = inv(A) * Y
% 
% 3-Evaluation at p
%
%	Zp = X(1:length(X)-1,1)' * z
%
%   where z is the colomn data vector
%
% 4- Variance at p 
%
%	Sp = X' * Y
%  
% Input description
% -----------------
%   data: The n x (p+d) data matrix. This data matrix can be imported from an
%      existing ascii file. Missing values are coded 'nan' (not-a-number).
%   x0: The m x d matrix of coordinates of points to estimate.
%   model: Each row of this matrix describes a different elementary structure.
%          The first column is a code for the model type, the d following
%          columns give the ranges along the different coordinates and the
%          subsequent columns give rotation angles (a maximum of three).
%          The codes for the current models are:
%             1: nugget effect
%             2: exponential model
%             3: gaussian model
%             4: spherical model
%             5: linear model
%             6: quadratic
%             7: power (h^b)
%             8: logarithmic
%             9: sinc; i.e. sin(h) / h
%            10: Bessel [ Jo (h) ]
%            11: exp(-h)   * cos(bh)
%            12: exp(-h)   *  Jo(bh)
%            13: exp(-h^2) * cos(bh)
%            14: exp(-h^2) *  Jo(bh)
%	     15: exp(-h^2) * (1 - br^2)
%   b: b coefficient
%   c: The (rp x p) coefficient matrix of the coregionalization model.
%      Position (i,j) in each submatrix of size p x p give the sill of the
%      elementary component for each cross-variogram (variogram) between
%      variable i and variable j.
%
% Output description:
% -------------------
%   For the usual application, only x0s and s are required and the other
%   output matrices may be omitted.
%
%   Zp: m x d kriged estimate matrix
%   Sp: m x d variance matrix

% Possible models

Gam=['h==0                                          '; % 1. nugget
     '1-exp(-h)                                     '; % 2. exponential
     '1-exp(-(h).^2)                                '; % 3. gaussian
     '(1.5*min(h,1)/1-.5*(min(h,1)/1).^3)           '; % 4. spherical
     'min(1,h)                                      '; % 5. linear
     '2*min(h,1) + min(h,1).^2                      '; % 6. quadratic
     'h.^b                                          '; % 7. power
     '1 - log10(h)                                  '; % 8. logarithmic
     '1 - sin(h) ./ b*h                             '; % 9. sinc
     '1 - bessel(0,h)                               '; %10. Bessel
     '1 - exp(-h)    .* cos(b*h)                    '; %11. cosine
     '1 - exp(-h)    .* bessel(0,b*h)               '; %12. Bessel
     '1 - exp(-h.^2) .* cos(b*h)                    '; %13. cosine
     '1 - exp(-h.^2) .* bessel(0,b*h)               '; %14. Bessel
     '1 - exp(-h.^2) .* (1 - b*r.^2)                '];%15.

% Parameter

n = length(data);
x = data(:,1);
y = data(:,2);
z = data(:,3);

% Evaluation of matrix A

if nargin == 6
for i = 1:n
   for j = 1:n
	dx = x(i) - x(j);
	dy = y(i) - y(j);
 	r  = sqrt (dx*dx + dy*dy);
	h  = r / a;

	A(j,i) = c*eval(Gam(model,:));
   end
end

A(n+1,:) = ones(1,n);
A(:,n+1) = [ones(n,1); 0];

save A2 A
end

% Evaluation of vectors Y and then X

np = length(x0)

for k = 1:np
  disp(['Doing ' int2str(k) ' out of ' int2str(np)])
 
  % interpolation position
	xp = x0(k,1);
	yp = x0(k,2); 	

	for i = 1:n
	   
  % vector Y
	   dxp = x(i) - xp;
	   dyp = y(i) - yp;
	   rp  = sqrt ( dxp*dxp + dyp*dyp);
	   h   = rp / a;

	   Y(i,1) = c*eval(Gam(model,:));
	end
	Y(n+1,1) = 1; 

  % vector X 
	X = inv(A) * Y;

  % weight vector: vector X with the last line missing
	W = X(1:length(X)-1,1);

  % interpolation at p
	Zp(k,1) = W' * z;

  % variance estimation
	Sp(k,1) = X' * Y;

end 
save Zp2 Zp
save Sp2 Sp


 	 
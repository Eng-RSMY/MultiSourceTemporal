function F = barnes (xi, yi, zi, c, g)

%	F = barnes (xi, yi, zi, c, g)
% 
% Filter kriged data.
% 
% 	F(i,j) = f0(i,j) + sum (wn * Dn) / sum (wn)
%
% où	f0(i,j)= barnes first estimation 
%	wn     = exp(-h^2 / (4*c*g)) = weigth function for x and y data
%	Dn     = zi-f0 (of coordinates (xi,yi))
%	c,g    = filter constants
%	F(i,j) = filtered data 	
%
% refs:	Tintoré et al. (1991) Mesoscale Dynamics and Vertical Motion in
%		the Alboran Sea, Journal of Physical Oceanigraphy, 21,811:823.
%
%	Maddox (1980) An Objective Technique for Separating Macroscale and 
%		Mesoscale Features in Meteorological Data, Montly Weather 
%		Review, 108, 1108:1121.

% Weigth function 

  wf0 = 'exp(-h.^2 ./ (4*c))';
  ww  = 'exp(-h.^2 ./ (4*c*g))';

% Input format: position
  
  nx = length(xi);
  ny = length(yi);
  p  = kregrid(min(xi),xi(2)-xi(1),max(xi),...
		min(yi),yi(2)-yi(1),max(yi));
  x = p(:,1);
  y = p(:,2);

% Input format: data
  
  [m,n] = size(zi);
  z = []; 
  for i = 1:n
	z = [z;zi(i,:)'];  
  end

% Sum over N: all data

  N = length(z);

% Filter to get f0(i,j)

 for j = 1:N
 
    dx = x - x(j);
    dy = y - y(j);
    h  = (dx.^2 + dy.^2) .^(0.5);
    wn = eval([wf0]);

    wf   = sum(wn .* z);
    w    = sum(wn);
    f0(j) = wf / w;

  end	

% Filter to get F(i,j)

  for j = 1:N
 
    dx = x - x(j);
    dy = y - y(j);
    h  = (dx.^2 + dy.^2) .^(0.5);
    wn = eval([ww]);

    wf   = sum(wn .* (z-f0'));
    w    = sum(wn);
    f(j) = wf / w;

  end	

% Output

  F = deplie(f0+f,nx,ny);
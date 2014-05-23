function [F2, Fb] = tintore(xi, yi, zi)

%	[F2, Fb] = tintore (xi, yi, zi)
%
% Separation scale function using the parameter of Tintoré et al. (1991)
% for the Alboran Sea.
%
% Input: xi,yi : Coordinates of the grid 
%	 zi    : Gridded data
%	 
% Output: F2   : macrocale grid
%	  Fb   : mesoscale grid 

% Filter response

  f1 = filresp(125,0.4);    % smoothing
  f2 = filresp(1000,0.6);   % macro	
  r  = max(f1-f2); 	    % normalisation factor needed in the scale separation

% Filtering the 'zi' matrix

  F1 = barnes(xi,yi,zi,125,0.4);	% smoothing of the original field
  F2 = barnes(xi,yi,zi,1000,0.4);	% macroscale field
  Fb = (F1-F2) ./ r;			% mesoscale field
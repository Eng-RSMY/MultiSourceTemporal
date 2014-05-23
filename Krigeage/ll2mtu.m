	function [x, y, k] = ll2mtu (phi0, lambda0, phi, lambda)
%
% LL2MTU: transformation des coordonnees spheriques de position en
%         coordonnees cartesiennes par une projection Mercator
%         transverse de l'ellipsoide de Clarke (1866).
%
%         [x, y, k] = ll2mtu (phi0, lambda0, phi, lambda)
%
%         x       premiere coordonnee cartesienne
%         y       seconde coordonnee cartesienne
%         k       facteur de deformation relative tout
%                 au long du parallele de latitude phi
%         phi0    latitude a l'origine des coordonnees cartesiennes
%         lambda0 longitude a l'origine des coordonnees
%                 cartesiennes correspondant au meridien
%                 central de la projection
%         phi     latitude du parallele de la coordonnee spherique
%         lambda  longitude du meridien de la coordonnee spherique

%	   
%  Pierre VINET
%  Departement d'oceanographie
%  Universite du Quebec a Rimouski
%  310 allee des Ursulines, Rimouski, Quebec, G5L 3A1
%  (418)723-1986 p_vinet@uqar.uquebec.ca
%                   
% ref : SNYDER, J. P. (1987).  Map Projections- A Working Manual,
%                              U. S. Geological Survey professionnal paper 1395,
%                              Washington, 383 pages.

%
%-- Conversion des angles en radians
	phi0    = deg2rad(phi0);
	lambda0 = deg2rad(lambda0);
	phi     = deg2rad(phi);
	lambda  = deg2rad(lambda);
%
%-- Ellipsoide de Clarke (1866); cf: table 1, page 12. 
	a  = 6378206.4;                 % Rayon terrestre equatorial
	b  = 6356583.8;                 % Rayon terrestre polaire
%       f  = (1./294.98);               % Applatissement
	e2 = 0.006768658;               % Carre de l'excentricite; page 13.
	e4 = e2.*e2;
	e6 = e4.*e2;
%
%-- Facteur de deformation au meridien central de longitude phi0
%   lors d'une projection MTU
	k0 = 0.9996;                   % page 61.
%
%-- Distance vraie de l'equateur a la latitude phi1 
%   le long du meridien central lambda0; eq. 3-21
	phi1 = phi;
        M    = a.*((1 - (e2./4) - (3./64).*e4 - (5./256).*e6).*phi1 ...
             - ((3./8).*e2 + (3./32).*e4 + (45./1024).*e6).*sin(2.*phi1) ...
             + ((15./256).*e4 + (45./1024).*e6).*sin(4.*phi1) ...
             - ((35./3072).*e6).*sin(6.*phi1));
	phi1 = phi0;
        M0   = a.*((1 - (e2./4) - (3./64).*e4 - (5./256).*e6).*phi1 ...
             - ((3./8).*e2 + (3./32).*e4 + (45./1024).*e6).*sin(2.*phi1) ...
		     + ((15./256).*e4 + (45./1024).*e6).*sin(4.*phi1) ...
		     - ((35./3072).*e6).*sin(6.*phi1));
%
%-- Cas des poles
	pis2 = pi./2;
	if phi == pis2 | phi == -pis2,
	   x = 0;
	   y = k0.*(M - M0);
	   k = k0;
	   return
        end
%
	ep2 = e2./(1-e2);                           % eq. 8-12
	N   = a./((1 - (e2.*(sin(phi).^2))).^0.5);  % eq. 4-20
%
	T  = tan(phi).^2;                           % eq. 8-13
	T2 = T.*T;
%
        C  = ep2.*(cos(phi).^2);                    % eq. 8-14
	C2 = C.*C;
%
	A  = (lambda - lambda0).*cos(phi);          % eq. 8-15
	A2 = A.*A;
	A3 = A2.*A;
	A4 = A3.*A;
	A5 = A4.*A;
	A6 = A5.*A;
%
%-- Developpement en serie pour x, y, k; eqs 8-9, 8-10 et 8-11.
	x = k0.*N.*(A + (1 - T + C).*A3./6 ...
            + (5 - 18.*T + T2 +72.*C - 58.*ep2).*A5./120);
        y = k0.*(M - M0 + N.*tan(phi).* ...
	    (A2./2 + (5 - T + 9.*C + 4.*C2).*A4./24 ...
            + (61 - 58.*T + T2 + 600.*C - 330.*ep2).*A6./720));
        k = k0.*(1 + (1 + C).*A2./2 ...
	    + (5 - 4.*T + 42.*C + 13.*C2 - 28.*ep2).*A4./24 ...
	    + (61 - 148.*T + 16.*T2).*A6./720);
%
	return
%	end
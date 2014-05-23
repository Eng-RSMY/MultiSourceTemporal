function R = filresp (c,g)
%
% Filter response in the wavelength domain
%
%	R = R0 (1 + R0^(g-1) - R0^g)
%
% where R0 = exp(-pi^2 * 4c /lamda^2)
%
% ref: Maddox, R.A. (1980) An objective Technique for Separating Macroscale 
%		and Mesoscale Features in Meteorological Data, Monthly Weather
%		Review, 108, 1108:1121.
%

% wavelength scale

  lamda = 10:1:500;

% R0 evaluation

  p = pi^2 * 4 * c;
  lamda2 = lamda.^2;

  R0 = exp(-p./lamda2);

% Filter response evaluation

  R = R0 .* (1 + R0.^(g-1) - R0.^g);

% Plot of the filter response

  plot(lamda,R,'m')
  xlabel ('Wavelength (distance unit)')
  ylabel ('Filter response')
  title ('Filter response in the wavelength domain')  
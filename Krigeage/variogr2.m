function [y, dyda] = variogr2(ctype, r, a, C, b)
%
%
%   y = variogr2 ( ctype, r, a, C, b)
%
% Fonction variogr.m modifiée pour ceux qui ne possèdent pas le 
% Optimization Toolbox de MATLAB.
%
%     ctype > 0 : calcul du variogramme théorique à 1-D
%     ctype < 0 : correlogramme [ C(r) = 1 - V(r) ]
%
%      r = vecteur des distances
%      a = seuil
%      C = facteur d'échelle
%      b = n'est utilisé que pour les modèles à trous
%   ctype = type de variogramme:
%            
%      modèles avec seuils:
%   type = 01 = sphérique  % not available
%          02 = exponentiel
%          03 = gaussien
%          04 = quadratique (non disponible)
%          05 = lineaire
%
%      modèles sans seuils:
%          10 = logarithmiques (non disponible)
%          11 = puissances de r (non disponible)
%          
%      modèles à trous (hole effects !!!)
%          20 = C * [ 1 - (sin b*r) / r ]
%          21 = C * [ 1 - (exp(-r/a))     * cos(br) ]
%          22 = C * [ 1 + (exp(-r/a))     * cos(br) ]
%          23 = C * [ 1 - (exp(-(r/a)^2)  * cos(br) ]
%          24 = C * [ 1 + (exp(-(r/a)^2)) * cos(br) ]
%          25 = C * [ 1 -                   Jo (br) ] % not available
%          26 = C * [ 1 - (exp-(r/a))     * Jo (br) ]
%          27 = C * [ 1 - (exp-(r/a)^2)   * Jo (br) ]
%	   28 = C * [ 1 - (exp-(r/a)^2)   * (1 - br)]
%
% dyda(1) = dérivée de y selon a
% dyda(2) = dérivée de y selon b
% dyda(3) = dérivée de y selon C  
%
  type = abs( ctype );
  ra = r ./ a;
%
% Semivariogrammes
%
  if type == 1
     y = 1.5 .* ra -  0.5 .* ra.^3;
     dyda(1) = -1.5*r/a^2 + 1.5*r.^3/a^4;
     dyda(2) = 0;
     dyda(3) = 0;
  end
%
  if type == 2
     y = C * ( 1 - exp(-(r/a)));
     dyda(1) = -C*r/a^2 .* exp(-(r/a));
     dyda(2) = 0;   
     dyda(3) = y/C;
  end
%    
  if type == 3
     y = C * ( 1 - exp(-(r/a).^2));
     dyda(1) = -2*C*r.^2/a^3 .* exp(-(r/a).^2);
     dyda(2) = 0;
     dyda(3) = y/C;
  end
%    
  if type == 5
     y = C .* r;
     dyda(1) = 0;
     dyda(2) = 0;
     dyda(3) = y/C;
  end   
%
  if type == 20
     y = C .* ( 1 - sin(b.*r)./r );
     dyda(1) = 0;
     dyda(2) = -C * cos(b*r);
     dyda(3) = y/C;
  end
%
  if type == 21
     y = C * ( 1 - exp(-r/a) .* cos(b*r) );
     dyda(1) = -C*r/a^2 .* exp(-r/a) .* cos(b*r);
     dyda(2) = C*r .* exp(-r/a) .* sin(b*r);
     dyda(3) = y/C;
  end
%
  if type == 22
     y = C * ( 1 + exp(-r/a) .* cos(b*r) );
     dyda(1) = C*r/a^2 .* exp(-r/a) .* cos(b*r);
     dyda(2) = -C*r .* exp(-r/a) .* sin(b*r);
     dyda(3) = y/C;
  end
%
  if type == 23
     y = C * ( 1 - exp(-(r/a).^2) .* cos(b*r) );
     dyda(1) = -2*C*r.^2/a^3 .* exp(-(r/a).^2) * cos(b*r);
     dyda(2) = C*r .* exp(-(r/a).^2) .* sin(b*r);
     dyda(3) = y/C;
  end
%
  if type == 24
     y = C * (1 + exp(-(r/a).^2) .* cos(b*r) );
     dyda(1) = 2*C*r.^2/a^3 .* exp(-(r/a).^2) .* cos(b*r);
     dyda(2) = -C*r .* exp(-(r/a).^2) .* sin(b*r);
     dyda(3) = y/C;
  end
%
  if type == 25
     y = C * (1 - bessel(0, b*r) );
     dyda(1) = 0;
     dyda(2) = C*r .* bessel(1,b*r);
     dyda(3) = y/C;
  end
%
  if type == 26
     y = C * ( 1 - bessel(0, b*r) .* exp(-r/a) );
     dyda(1) = -C*r/a^2 .* bessel(0,b*r) .* exp(-r/a);
     dyda(2) = C*r .* bessel(1,b*r) .* exp(-r/a);
     dyda(3) = y/C;
  end
%
  if type == 27
     y = C * ( 1 - exp(-(r/a).^2) .* bessel(0,b*r) ); 
     dyda(1) = -2*C*r.^2/a^3 .* bessel(0,b*r) .* exp(-(r/a).^2);
     dyda(2) = C*r .* bessel(1,b*r) .* exp(-(r/a).^2);
     dyda(3) = y/C;
  end
% 
  if type == 28
     y = C * ( 1 - exp(-(r/a).^2) .* (1 - b*r.^2) );
     dyda(1) = -2*C*r.^2/a^3 .* (1-b*r.^2) .* exp(-(r/a).^2);
     dyda(2) = C*r.^2 .* exp(-(r/a).^2);
     dyda(3) = y/C;
  end
%
% Correlogrammes
%
  if ctype < 0
     y = 1 - y;
  end
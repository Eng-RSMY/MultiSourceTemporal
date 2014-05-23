function y = variogr(ctype, r, a, C, b)
%
%
%   y = variogr ( ctype, r, a, C, b)
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
%   type = 01 = sphérique
%          02 = exponentiel
%          03 = gaussien
%          04 = quadratique (non disponible)
%          05 = lineaire + plateau
%
%      modèles sans seuils:
%          10 = logarithmiques (non disponible)
%          11 = puissances de r (non disponible)
%          
%      modèles à trous (hole effects !!!)
%          20 = C * [ 1 - (sin b*r) / r ]
%          21 = C * [ 1 - (exp(-r/a))     * cos(br) ]
%          22 = C * [ 1 + (exp(-r/a))     * cos(br) ]
%          23 = C * [ 1 - (exp(-(r)/a)    * cos(br) ]
%          24 = C * [ 1 - (exp(-(r/a)^2)) * cos(br) ]
%          25 = C * [ 1 -                   Jo (br) ]
%          26 = C * [ 1 - (exp-(r/a))     * Jo (br) ]
%          27 = C * [ 1 - (exp-(r/a)^2)   * Jo (br) ]
%	   28 = C * [ 1 - (exp-(r/a)^2)   * (1 - br)]
%
%
%
type = abs( ctype );
n = length(r);
debut = find ( r < a );
m = length(debut);
seuil = n - m;
ra = r ./ a;
%
if type == 1
   y = 1.5 .* ra  -  0.5 .* ra.^3;
%   y( m+1 : n) = C .* ones(seuil,1);
%   y( debut ) = 1.5 .* ra(debut)  -  0.5 .* ra(debut).^3;
end
%
if type == 2
   y = C * ( 1 - exp(-(r/a)));
end
%    
if type == 3
   y = C * ( 1 - exp(-(r/a).^2));
end
%    
if type == 5
   y = C .* r;
%   y(debut) = C .* r(debut);
%   y(m+1:n) = C*a .* ones(seuil,1);
end   
%
if type == 20
   y = C .* ( 1 - sin(b.*r)./r );
end
%
if type == 21
   y = C * ( 1 - exp(-r/a) .* cos(b*r) );
end
%
if type == 22
   y = C * ( 1 + exp(-r/a) .* cos(b*r) );
end
%
if type == 23
   y = C * ( 1 - exp(-r/a) .* cos(r*b) );
end
%
if type == 24
   y = C * (1 - exp(-(r/a).^2) .* cos(b*r) );
end
%
if type == 25
   y = C * ( 1 - bessel(0, b*r) );
end
%
if type == 26
   y = C * ( 1 - bessel(0, b*r) .* exp(-r/a) );
end
%
if type == 27
   y = C * ( 1 - exp(-(r/a).^2) .* bessel(0, b*r) );
end
%
if type == 28
   y = C * ( 1 - exp(-(r/a).^2) .* (1 - b*r.^2) );
end
%
if ctype < 0
   y = 1 - y;
end
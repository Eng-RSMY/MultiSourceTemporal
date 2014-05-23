function fitvario (model,data,a,b)

% 	fitvario (model,data,a,b)
%
% Fonction qui permet d'obtenir la combinaison optimale des
% param�tres 'a', 'b' et 'c' de la fonction 'variogr.m'
% 
% Input: model -> type de mod�le de la fonction 'variogr.m'
% 	 data(:,1) -> abscisse (distance) (gam(:,1))
% 	 data(:,2) -> ordonn�e (variance) (gam(:,2))
%	 a et b	-> param�tres approximatifs de 'variogr.m'
%
% Output: graphique de la variance en fonction de la distance
%	  
% Fait appel �: LEASTSQ.m et FUN.m

% Variables globale

  global m
  m = model;

% Graphique des donn�es

  clf
  plot(data(:,1),data(:,2),'o')

% Least-square fitting

  if nargin == 4
    lam = [a b] ;
  elseif nargin == 3
    lam = [a];
  end

  [lam,option] = leastsq ('fun',lam,[],[],data);
 
% labels and title

  xlabel('Distance')
  ylabel('Semivariance')
  title (['Mod�le ' num2str(model)]) 

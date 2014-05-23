function fitvario (model,data,a,b)

% 	fitvario (model,data,a,b)
%
% Fonction qui permet d'obtenir la combinaison optimale des
% paramètres 'a', 'b' et 'c' de la fonction 'variogr.m'
% 
% Input: model -> type de modèle de la fonction 'variogr.m'
% 	 data(:,1) -> abscisse (distance) (gam(:,1))
% 	 data(:,2) -> ordonnée (variance) (gam(:,2))
%	 a et b	-> paramètres approximatifs de 'variogr.m'
%
% Output: graphique de la variance en fonction de la distance
%	  
% Fait appel à: LEASTSQ.m et FUN.m

% Variables globale

  global m
  m = model;

% Graphique des données

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
  title (['Modèle ' num2str(model)]) 

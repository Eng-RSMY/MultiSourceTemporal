function f = fun(lam,data)

% 	f = fun(lam,data)
%
% Fonction à optimisée
%
% Input: lam  -> [a;b] ou [a]
%	 data -> [distance variance]
%
% Output: f -> fonction optimisée
%
% Fait appel à: VARIOGR.m

% Variable globale

  global m

% Données
 
  x = data(:,1);
  y = data(:,2);

% Calcul de la fonction selon les paramètres de 'lam'

  if length(lam) == 2
    yr = variogr(m,x,lam(1),1,lam(2));
  else
    yr = variogr(m,x,lam(1),1);
  end

% Calcul de 'c'

  c = yr\y;

% Calcul de la fonction en tenant compte de 'c'

  z = yr * c;

% Calcul de l'erreur sur le fitting

  f = z - y;

% Statements to plot progress of fitting

  plot(x,z,x,y,'o')
  xx = max(x) /3;
  yy = max(y) /4;

  text (xx,1.6*yy,['a = ' num2str(lam(1))])
  if length(lam) == 2
    text (xx,1.2*yy,['b = ' num2str(lam(2))])
    text (xx,0.8*yy,['c = ' num2str(c)])
    text (xx,0.4*yy,['err norm = ' sprintf('%g',norm(f))])
    a = lam(1);
    b = lam(2);
    save fit a b c
  else
    text (xx,1.2*yy,['c = ' num2str(c)])
    text (xx,0.8*yy,['err norm = ' sprintf('%g',norm(f))])	
    a = lam(1);
    b = 0;
    save fit a c b
  end

function fitvari2 (model,data,a,b,C)

% 	fitvari2 (model,data,a,b,C)
%
% Fonction bas�e sur fitvario.m et qui ne n�cessite pas le 
% Optimization Toolboox.
%
% Fonction qui permet d'obtenir la combinaison optimale des
% param�tres 'a', 'b' et 'c' de la fonction 'variogr.m'
% 
% Input: model -> type de mod�le de la fonction 'variogr.m'
% 	 data(:,1) -> abscisse (distance) (gam(:,1))
% 	 data(:,2) -> ordonn�e (variance) (gam(:,2))
%	 a, b et C -> param�tres approximatifs de 'variogr.m'
%
% Output: graphique de la variance en fonction de la distance
%	  
% Fait appel �: MRQMIN.m, VARIOGR2.m, GAUSSJ.m, MRQCOF.m, COVSRT.m
%
% C. Lafleur, INRS-Oc�anologie, 13-01-98

% Variables globale

  m = model;

% Graphique des donn�es

  clf
  plot(data(:,1),data(:,2),'o')

% Least-square fitting

  if nargin == 5
    lam = [a b C] ;
  elseif nargin == 4
    lam = [a 0 b];
  end

% Optimisation

    x = data(:,1);
    y = data(:,2);
    maxy = max(y);
    y = y/maxy;
    stdy = 1e-10 + abs(0.05*y);

% V�rifacation des valeurs de x pour le mod�le #20

  if m == 20 & ~isempty(find(x==0)),
    error('x ne peut avoir la valeur de 0')
  end

% - Si mod�le = 5: lin�aire 
   
  if m==5
	lam=[0 0 C];      

% - Si mod�le autre

  else
    if m == 20, ia = [0 1 1]; lam(1) = 0; end
    if m <  20, ia = [1 0 1]; lam(2) = 0; end
    if m >  20, ia = [1 1 1]; end
    if m == 25, ia = [0 1 1]; lam(1) = 0; end
    if m == 1,  ia = [1 0 0]; lam(2) = 0; lam(3) = 0; end

    i=0;
    chisq  = 0;
    chisq0(1) = 100;
    chisq0(2) = 100;
    niv = 1e-10;		% niveau de confiance
    while abs(chisq-chisq0(2)) > niv
      i = i+1;
      chisq0(2) = chisq0(1);
      chisq0(1) = chisq;
      if i == 1; alamda = -1; end
      [covari,alpha,chisq,alamda,lam] = ...
         mrqmin (x,y,stdy,length(x),lam,ia,3,3,'variogr2',alamda,m);
      chisq;
      if lam(2) < 0
	chisq = chisq0(2);
	if ~isempty(find(x == 0))
	  disp('�viter la valeur de x = 0')
        else
    	  disp('Param�tres trop �loign�s de ceux recherch�s')
      	  disp('Refaire l''op�ration avec de nouveaux param�tres')
 	end
      end
      if i == 50
	chisq = chisq0(2);
	disp('Le nombre maximum d''it�rations a �t� atteint sans convergence des param�tres');
      end
    end
   
    if i==3
      disp('Param�tres trop �loign�s de ceux recherch�s')
      disp('Refaire l''op�ration avec de nouveaux param�tres')
    end	      

    [covari,alpha,chisq,alamda,lam] = ...
        mrqmin (x,y,stdy,length(x),lam,ia,3,3,'variogr2',0,m);
    end
  
% Param�tre optimis�

  for i = 1:length(x)
    [yr(i),dyda(i,:)] = variogr2(m,x(i),lam(1),1,lam(2));
  end
  c = yr'\y;  
  c = c*maxy;
  y = y*maxy;
  z = yr' * c;

% Calcul de l'erreur sur le fitting

  f = z - y;

% Statements to plot progress of fitting

  plot(x,z,x,y,'o')
  xx = (max(x) - min(x)) /3;
  yy = (max(y) - min(y)) /4;
  mx = min(x);
  my = min(y);

  text (mx+xx,my+1.6*yy,['a = ' num2str(lam(1))])
  if b ~= 0
    text (mx+xx,my+1.2*yy,['b = ' num2str(lam(2))])
    text (mx+xx,my+0.8*yy,['c = ' num2str(c)])
    text (mx+xx,my+0.4*yy,['err norm = ' sprintf('%g',norm(f))])
    a = lam(1);
    b = lam(2);
    save fit a b c
  elseif b == 0
    text (mx+xx,my+1.2*yy,['c = ' num2str(c)])
    text (mx+xx,my+0.8*yy,['err norm = ' sprintf('%g',norm(f))])	
    a = lam(1);
    b = 0;
    save fit a c b
  end

% labels and title

  xlabel('Distance')
  ylabel('Semivariance')
  title (['Mod�le ' num2str(model)]) 

% Demo du KRIGING TOOLBOX
colordef black
clc
echo on
% --------------------------------------------------------
%	    KRIGING TOOLBOX DEMO: version 3.0
% --------------------------------------------------------
%   
% Interpolation objective de la salinité à 15 m sous la 
% surface de l'estuaire maritime du St-Laurent en juillet
% 1990. 
%
% La distribution de la salinité est considérée isotrope
% et l'ensemble des échantillons est utilisé pour interpoler
% la salinité à chaque point de grille.
%
% Les fonctions présentées dans ce demo sont:
%   vario2di: variogramme option semi-variogramme  
%   fitvario: optimisation de la du semi-variogramme 
%   confint:  intervalles de confiance du semi-variogramme
%   kregrid:  création de la grille
%   cokri:    interpolation
%
% Caroline Lafleur, INRS-Océanologie
% version 3.0, février 1998
% Matlab version 5.1

% Carte des stations d''échantillonnage
% -------------------------------------
 
  figure('units','normal','Position',[0.4 0.1 0.58 0.8])
  subplot('Position',[0.2 0.2 0.6 0.6])
  plt90stn
  text(0.5,1.2,'Localisation des échantillons','Units',...
	'normalized','HorizontalAlignment','center',...
        'fontsize',14,'color','b')

  pause  % Appuyez sur une touche pour continuer
  clc   
% Calcule le variogramme de la salinité
% -------------------------------------

 % 1- Données de salinité à 15 m

  load sal15
  x = sal15(:,1)./1000;		% Position x en km
  y = sal15(:,2)./1000;		% Position y en km
  z = sal15(:,3);		% Salinité

 % 2- Paramètres de vario2di

  nd     = length(x);	  % Nombre de données 			
  nlag   = 22;		  % Nombre d'intervalle de calcul
  xlag   = 3.5; 	  % Intervalle en km
  xltol  = 1.75;	  % Tolérance des intervalles
  ndir   = 1;		  % Nombre de direction
  azm    = 0; 		  % Angle azimutal de la direction
  atol   = 90;		  % Tolérance de l'angle azimutal
  bandw  = 80;		  % Largeur de bande de l'azimut (km)
  nvarg  = 2;		  % Nombre de variogrammes calculés
  ivtail = [1;1];	  % Variable 1
  ivhead = [1;1];	  % Variable 2
  ivtype = [1;4];	  % Type de variogrammes
  nvar   = 1;		  % Nombre de variables

 % 3- Variogramme

  [np,gam,hm,tm,hv,tv] = vario2di (nd,x,y,z,nlag,xlag,xltol,...
	ndir,azm,atol,bandw,nvarg,ivtail,ivhead,ivtype,nvar);

% Optimisation du semi-variogramme: modèle #21 de variogr
% -------------------------------------------------------

  I = find(np(:,2) >= 20);
%  fitvario(21,gam(I,1:2),100,0.08)	% with the optimization toolbox
  fitvari2 (21,gam(I,1:2),100,0.08,1)	% without the optimization toolbox
  refresh
  xlabel('Distance (km)')
  ylabel('Variance (psu²)')
  title('Variogramme','fontsize',14,'color','b')
  echo off

% Calcul et trace les intervalles de confiance de 95%
 
  yesno = input('Désirez-vous voir les intervalles de confiance (o/n)? ','s');
  clc
  if ~isempty(yesno) & yesno == 'o'
    for i = 1:length(I)
       [k1, k2] = confint(0.95,np(I(i),2),gam(I(i),2)); hold on
       plot(ones(1,2)*np(I(i),1),[k1,k2],'-g')
    end

  disp ('Appuyez sur une touche pour continuer'), pause,clc
  end  
  echo on

% Interpolation objective
% -----------------------

 % 1- Paramètres obtenus de l'optimisation

  data = [x y z];	% Données
  mod = 11;		% Modèle de variogramme 	
  load fit		% Paramètre a, b, c
  b   = 0.086*a;	% Paramètre b (changement de variable de r à h)
  
 % 2- Position des points de la grille à interpoler

  [x0, nx, ny] = kregrid (150,2.5,222.5,5360,2.5,5430);

 % 3- Entrées de la fonction cokri

  model = [mod a];	% Modèle	
  itype = 2;		% Type d'interpolation
  avg   = mean(z);	% Moyenne de la salinité
  block = [1 1];	% Krigeage ponctuel
  nd    = [1 1];	% Intervalle de krigeage
  ival  = 0;		% Validation
  nk    = length(z);	% Estimation avec tous les points
  rad   = 80;		% Rayon de recherche (km)
  ntok  = 1;		% Krigeage d'un seul point à la fois

 % 4- Krigeage  

   yesno = 'o';

   if yesno == 'o'
     [x0s,s,sv,id,l] = cokri (data,x0,model,c,itype,avg,block,nd,ival,nk,rad,ntok,b);
     zi = deplie(x0s(:,3),nx,ny);
     szi = deplie(s(:,3),nx,ny); 
   else 
     load kri
   end

% Résultats du krigeage
% ---------------------
echo off
 % 1- Bathymétrique

  load bathy

 % 2- Masque les points de grille icorrect

  [l,n] = size(bathy);
  smin = 23; smax = 31; ds = 1; z = 15;
  for i = 1:l
    I = find (bathy(i,:) < z);
    zi(i,I)  = zi(i,I) .*nan;
    szi(i,I) = szi(i,I).*nan;
    bat(i,I) = bathy(i,I).*nan;
  end

 % 3- Trace le contour de la salinité

  xi = 150:2.5:222.5;
  yi = 5360:2.5:5430;
  
  clf  
  subplot('Position',[0.2 0.2 0.6 0.6])
  colormap (gray(8))
  pcolor (xi*1000,yi*1000,zi);
  shading interp
  caxis([smin,smax])
  text(0.5,1.2,'Salinité à 15 m','Units','normalized',...
	'HorizontalAlignment','center','fontsize',14,...
	'color','b')
  hold on

 % 4- Trace la côte

  plt90stn

 % 5- Trace l'échelle de couleur

  subplot('Position',[0.3 0.08 0.4 0.04])
  colormap (gray(8))
  map = pcolor([smin:ds:smax],[1,2],[smin:ds:smax;smin:ds:smax]);
  shading flat
  set (gca,'yticklabel',[],'xlim',[smin+1,smax-1],...
	'xtick',smin+1:ds:smax-1,'Fontsize',9)


  disp('Appuyez sur une touche pour continuer'), pause

 % 6- Trace le contour de l'erreur = sqrt(variance)

  clf 
  subplot('Position',[0.2 0.2 0.6 0.6])
  g = jet(5);
  colormap (g);
  [c,h] = contour(xi.*1000,yi.*1000,sqrt(szi),(0.2:0.2:1.0));
  hold on
  plt90stn
  text(0.5,1.2,'Erreur d''interpolation','color','b',...
        'Units','Normalized','HorizontalAlignment',...
        'center','fontsize',14)
  text(0.0,-0.2,'0.2','color',g(1,:),'Units','Normalized','HorizontalAlignment','center','fontsize',14)
  text(0.25,-0.2,'0.4','color',g(2,:),'Units','Normalized','HorizontalAlignment','center','fontsize',14)
  text(0.50,-0.2,'0.6','color',g(3,:),'Units','Normalized','HorizontalAlignment','center','fontsize',14)
  text(0.75,-0.2,'0.8','color',g(4,:),'Units','Normalized','HorizontalAlignment','center','fontsize',14)
  text(1.0,-0.2,'1.0','color',g(5,:),'Units','Normalized','HorizontalAlignment','center','fontsize',14)

  disp ('Appuyez sur une touche pour continuer'),pause
  disp (' ')
  disp ('Fin du demo')
  disp ('-----------------------------------------------') 
  
  clear
  close
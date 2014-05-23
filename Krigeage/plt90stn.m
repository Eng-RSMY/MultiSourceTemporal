function plt90stn

%	plt90stn
%
% Trace la carte (MTU) de la region de COUPPB90
% (cote et isobathe de 200m)
% Centre de la carte: -68.65, 48.70
% Zero de la carte: -71.1, 0.0

% C.Lafleur 17-08-94
% Programme base sur pltctr.m
%
load c90
maxx=max(c90(:,1));
maxy=max(c90(:,2));
minx=maxx;
miny=maxy;
hold on

% Trace la cote

fin = max ( size(c90) );
n=1;
while n < fin
k = c90( n, 2);
plot( c90(n+1:n+k, 1) , c90(n+1:n+k, 2),'w-','linewidth',0.7);
minxx=min(c90(n+1:n+k,1));
minx=min(minxx,minx);
minyy=min(c90(n+1:n+k,2));
miny=min(minyy,miny);
n = n + k + 1;
end

% Trace le cadre

plot([minx maxx],[miny miny],'w')
plot([minx minx],[miny maxy],'w')
plot([minx maxx],[maxy maxy],'w')
plot([maxx maxx],[miny maxy],'w')


% Trace la position des CTD

load ctd_utm
p = ctd;
n = length(p);
for i=1:n
  if p(i,1)>minx & p(i,1)<maxx & p(i,2)>miny & p(i,2)<maxy
	plot(p(i,1),p(i,2),'r.','markersize',11.5)
	if p(i,3) < 10 
	   num = ['0' int2str(p(i,3))];
	else
	   num = int2str(p(i,3));
	end
%	text(p(i,1)+2000,p(i,2),num,'fontsize',9);
  end
end

% Determination des axes 

h=gca;
set(gca,'Visible','off','DataAspectRatio',[1 1 1])
set(gca,'PlotBoxAspectRatio',[maxx-minx maxy-miny 1])
set(gca,'XLim',[minx maxx],'YLim',[miny maxy])

% Trace l'echelle

x1=200000;
x2=220000;
y1=5350000;
plot([x1 x2],[y1 y1],'w')
plot([x1 x1],[y1 y1+1000],'w')
plot([x2 x2],[y1 y1+1000],'w')
plot([x1+(x2-x1)/2 x1+(x2-x1)/2],[y1 y1+1000],'w')
text(x1-700,y1-1800,'0','fontsize',11)
text(x1+(x2-x1)/2-1200,y1-1800,'10','fontsize',11)
text(x2-1200,y1-1800,'20 km','fontsize',11)


% localisation des principales villes

[x,y,k] = ll2mtu(0,-71.1,48.413,-68.5);
plot(192390,5365300,'g.','markersize',17)
text(x+2000,y,'Rimouski','FontSize',12,'HorizontalAlignment','left')

% graduation en degré

coorh = [-69.4 49; -69.4 48.5; -67.9 49; -67.9 48.5];
coorv = [-69 49.2; -68 49.2; -69 48.2; -68 48.2];
[coorh ones(4,1)];
[ch(1,1), ch(1,2)] = ll2mtu(0, -71.1, coorh(1,2), coorh(1,1));
[ch(2,1), ch(2,2)] = ll2mtu(0, -71.1, coorh(2,2), coorh(2,1));
[ch(3,1), ch(3,2)] = ll2mtu(0, -71.1, coorh(3,2), coorh(3,1));
[ch(4,1), ch(4,2)] = ll2mtu(0, -71.1, coorh(4,2), coorh(4,1));
cv = stn2utm([coorv ones(4,1)],-71.1);
plot(minx*ones(2,1),ch(1:2,2),'w+');
text((minx-3000)*ones(2,1),ch(1:2,2),['  ' int2str(coorh(1,2)) '°N';'48°30'''],'HorizontalAlignment','right','Fontsize',10)
plot(maxx*ones(2,1),ch(3:4,2),'w+');
text((maxx+3000)*ones(2,1),ch(3:4,2),[int2str(coorh(3,2)) '°N  ';'48°30'''],'HorizontalAlignment','left','fontsize',10)
plot(cv(1:2,1),ones(2,1)*maxy,'w+');
text(cv(1:2,1),ones(2,1)*maxy+3000,[' ' int2str(abs(coorv(1,1))) '°'; int2str(abs(coorv(2,1))) '°O'],'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',10)
plot(cv(3:4,1),ones(2,1)*miny,'w+');
text(cv(3:4,1),ones(2,1)*miny-3000,[' ' int2str(abs(coorv(3,1))) '°'; int2str(abs(coorv(4,1))) '°O'],'VerticalAlignment','top','HorizontalAlignment','center','fontsize',10)

function out=stn2utm(stn,z1)

%	out = stn2utm(stn,z1)
%
% Function qui premet de transformer un fichier de station 
% ou autre des coordonnees (lat,long) en coordonnees UTM
%
% INPUT: stn: matrice des stations et de leur coordonnee (lat,long)
%	      (x=longitude,y=latitude,z=no de station)
%	 z1: latitude en degre du zero de la carte sur laquelle seront dessines 
%	     station
%
% OUTPUT: out: matrice des stations et de leur coordonnee UTM
%              (x=longitude,y=latitude,z=no de station)

% C. Lafleur   18-08-94


[l,n]=size(stn);
for i=1:l
	[x(i),y(i),k(i)]=ll2mtu(0,z1,stn(i,2),stn(i,1));
end

out=[x',y',stn(:,3)];
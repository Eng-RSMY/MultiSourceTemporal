clear;
clc
latilim = [20 50];
lonlim =  [-125 -65];

% S = shaperead('usastatehi','UseGeoCoords',true);
% load usamtx
% worldmap(map, refvec)
% geoshow(map, refvec, 'DisplayType', 'contour');
% demcmap(map)
% axis off
% geoshow([S.Lat], [S.Lon], 'Color', 'black');
load '../data/climateP17'
% 
% h = plotm(locations,'d');
% set(h,'Marker','square');
%%

figure; ax = usamap('all');
set(ax, 'Visible', 'off')
states = shaperead('usastatelo', 'UseGeoCoords', true,...
    'Selector',...
    {@(name) ~any(strcmp(name,{'Alaska','Hawaii'})), 'Name'});
names = {states.Name};
indexHawaii = strcmp('Hawaii',names);
indexAlaska = strcmp('Alaska',names);
indexConus = 1:numel(states);
indexConus(indexHawaii|indexAlaska) = [];
stateColor = [0.8 1 0.8];
geoshow(ax(1), states(indexConus),  'FaceColor', stateColor)
for k = 1:3
    setm(ax(k), 'Frame', 'off', 'Grid', 'off',...
        'ParallelLabel', 'off', 'MeridianLabel', 'off')
end

load solCli17Orth10L3.mat

N = size(series{1}, 1);
SolAgg = zeros(N);
nLag = size(Sol, 2)/size(Sol, 1);
for i = 1:17
    for ll = 1:nLag
        SolAgg = SolAgg + squeeze(abs(Sol(:, (ll-1)*N+1:ll*N, i)));
    end
end

lat= [];
lon = [];
u = [];
v = []; 
th = 0.2;

disp(sum(sum(SolAgg > th)))
scale = 1;
for i = 1:N
    for j = 1:N
        if (SolAgg(i, j) > th)
            lat = [lat, locations(j, 1)];
            lon = [lon, locations(j, 2)];
            u = [u, SolAgg(i, j)*scale*sign(locations(i, 1) - locations(j, 1))];
            v = [v, SolAgg(i, j)*scale*sign(locations(i, 2) - locations(j, 2))];
        end
    end
end

quiverm(lat,lon,u,v, 'r', scale)

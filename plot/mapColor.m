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
stateColor = [1 1 1];


load solCli17Orth10L3.mat

N = size(series{1}, 1);
SolAgg = zeros(N);
nLag = size(Sol, 2)/size(Sol, 1);
for i = 1:17
    for ll = 1:nLag
        SolAgg = SolAgg + squeeze(abs(Sol(:, (ll-1)*N+1:ll*N, i)));
    end
end

influence = mean(SolAgg, 1);

lats = unique(locations(:, 1));
lons = unique(locations(:, 2));

LAT = repmat(lats, 1, length(lons));
LON = repmat(lons', length(lats), 1);

results = zeros(length(lats), length(lons));
for i = 1:length(influence)
    results( lats == locations(i, 1), lons == locations(i, 2) ) = influence(i);
end

pcolorm(LAT,LON,results)

h = geoshow(ax(1), states(indexConus),  'FaceColor', stateColor);
for k = 1:3
    setm(ax(k), 'Frame', 'off', 'Grid', 'off',...
        'ParallelLabel', 'off', 'MeridianLabel', 'off')
end
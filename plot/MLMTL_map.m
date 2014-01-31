clear;
latilim = [20 50];
lonlim =  [-125 -65];

S = shaperead('usastatehi','UseGeoCoords',true);
load usamtx
worldmap(map, refvec)
geoshow(map, refvec, 'DisplayType', 'contour');
demcmap(map)
axis off
geoshow([S.Lat], [S.Lon], 'Color', 'black');
load '../data/climateP17'

h = plotm(locations,'d');
set(h,'Marker','square');
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



% load Group_idx
% colors = colormap(hsv(5));
% for i = 1:5
%     loc = locations(idx==i,:);
%     h = plotm(loc,'ks');
%     set(h,'MarkerSize',5,'MarkerFaceColor',colors(i,:));
% end
% 


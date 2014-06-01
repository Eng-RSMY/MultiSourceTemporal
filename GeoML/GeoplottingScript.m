% Plotting Script
clear

load qualityForGeo.mat
qFor = qualityGreedy;

load qualityOrthGeo.mat
qOrth = qualityGreedy;

quality = [qFor, qOrth, 0*qFor, 0*qFor];

for i = 1:17
    name = sprintf('MLGeo_ClimateP17_%d.mat', i);
    load(name)
    quality(i, 3) = Quality_Cvx.RMSE;
    quality(i, 4) = Quality_Mix.RMSE;
end

agents = [1 4 5 6 8 12 13 14 15 16];

load climate17GeoLR.mat
err = [err];
quality = [quality, err'];

subplot(3, 1, 1)
bar(quality(agents, :))
legend('Forward', 'Orthogonal', 'Convex', 'Mixture', 'No Geo')
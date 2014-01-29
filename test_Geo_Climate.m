clear;
clc;
addpath(genpath('~/Documents/MATLAB/MultiSourceTemporal'));
lambda = 316;
beta = 1e-2;
thres = 1e-4;

data  = load('climateP17.mat');
nType = length(data.series);


ratio = 0.1;

fprintf('start Multi-task Multi-linear Learning \n');
for type = 1:nType
%     [W_Cvx_geo, W_Mix_geo,~,~] = Kriging_Learn(data, lambda, beta ,pr);
    fprintf('type %d\n', type);
    [W_Cvx,W_Mix,Quality_Cvx,Quality_Mix] = Kriging_Learn_Single(data, lambda, beta, ratio, type);
    fname = strcat('./GeoML/MLGeo_ClimateP17_',int2str(type),'.mat');
    save(fname,'W_Cvx','W_Mix','Quality_Cvx','Quality_Mix');
 
end

exit;

%%
% plot([0.5:0.1:0.9],[ml_conv',geo_conv',ml_mix',geo_mix']);
% legend('Overlapped MTMLL','Overlapped GSMLL','Latent MTMLL','Latent GSMLL');



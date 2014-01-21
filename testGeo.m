clear;
clc;
addpath(genpath('GeoML'));
lambda = 316;
beta = 1e-2;
thres = 1e-4;

data  = load('./data/climateP17.mat');
dimModes = [125,125,17];

rank_Cvx = [];
rank_Cvx_geo = [];
rank_Mix = [];
rank_Mix_geo = [];

for pr = fliplr(0.3)
%     fprintf('start Geo-spatio Multi-linear Learning \n');
%     [W_Cvx_geo, W_Mix_geo,~,~] = Kriging_Learn(data, lambda, beta ,pr);
    fprintf('start Multi-task Multi-linear Learning \n');
    [W_Cvx,W_Mix,~,~] = MLMTL_Learn(data, lambda, beta, pr);

%     
%     [~,~,~,ratio] = tensorModeRank(reshape(W_Cvx, dimModes));
%     rank_Cvx = [rank_Cvx, ratio];
%     [~,~,~,ratio] = tensorModeRank(reshape(W_Mix, dimModes));
%     rank_Mix= [rank_Mix, ratio];
%     [~,~,~,ratio] = tensorModeRank(reshape(W_Cvx_geo, dimModes));
%     rank_Cvx_geo = [rank_Cvx_geo, ratio];
%     [~,~,~,ratio] = tensorModeRank(reshape(W_Mix_geo, dimModes));
%     rank_Mix_geo= [rank_Mix_geo, ratio];   
end

% save('testGeo.mat');

%%
plot([0.5:0.1:0.9],[ml_conv',geo_conv',ml_mix',geo_mix']);
legend('Overlapped MTMLL','Overlapped GSMLL','Latent MTMLL','Latent GSMLL');



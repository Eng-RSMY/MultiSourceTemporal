
% clear; clc; genData_ClimateP3;
load 'climateP17.mat'
nTasks = length(series);
nLocs = size(series{1},1);

%%
x = [];
time = 1;
x = [locations];
for t = 1: nTasks
    x = [x,  series{t}(:,time)];
end


missing_idx =[1:10]';
observe_idx = setdiff(1:nLocs, missing_idx);

x_observe = x;
x_observe(missing_idx,:) = NaN;
x0 = locations(missing_idx,:);
mod = 3; % quadratic
a = 1;
model = [mod ,a];% 

c = rand(17);% use cross-variogram for the c?
itype = 1; % simple kriging
avg = mean(x(observe_idx,3:end)); %average value
block = ones(1,2);
nd = ones(1,2);% point kriging
ival = 0; % no cross validation
nk = 1;
rad  = 80;
ntok = 1;% missing point group size
b   = 0.086*a;%never used?

[x0s,s,sv,idout,l,k,k0]=cokri(x_observe,x0,model,c,itype,avg,block,nd,ival,nk,rad,ntok,b);

%% evaluate


err_RMSE_cokriging = sqrt(norm_fro(x0s(:,3:end) -x(missing_idx,3:end))^2/numel(x0s(:,3:end)));

disp(err_RMSE_cokriging);
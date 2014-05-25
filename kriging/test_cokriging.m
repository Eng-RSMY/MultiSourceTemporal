
% clear; clc; genData_ClimateP3;
load 'climateP17.mat'

x = [];
time = 1;
x = [locations];
for t = 1: nTasks
    x = [x,  series{t}(:,time)];
end

tmp = X(:);
missing_idx =[1:10];
% for t = 1: nTasks
%     x = [x,  tmp];
% end
x_missing = x;
x_missing(missing_idx,:) = NaN;
x0 = locations(missing_idx,:);
model = [1 10; 4 30];% Gaussian model
c = rand(17,nTasks);% use cross-variogram for the c?
itype = 1; % simple kriging
avg = rand(1, nTasks); %average value
block = rand(1,2);
nd = ones(1,2);
ival = 0; % no cross validation
nk = 5;
rad  = 10;
ntok = 2;
b = rand(17, nTasks); %never used?

[x0s,s,sv,idout,l,k,k0]=cokri(x_missing,x0,model,c,itype,avg,block,nd,ival,nk,rad,ntok,b);

%% evaluate
err_RMSE_cokriging = 0;

err_RMSE_cokriging = err_RMSE_cokriging +  sqrt(norm_fro(x0s(:,2+t:end) -x(missing_idx,2+t:end))^2/numel(x0s(:,2+t:end)));

disp(err_RMSE_cokriging);
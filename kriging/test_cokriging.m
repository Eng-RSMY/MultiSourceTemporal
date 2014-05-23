
% clear; clc; genData_ClimateP3;

x = [];
time = 1;
x = [names(:,2:3)];
for t = 1: nTasks
    x = [x,  series{t}(:,time)];
end
x(missing_idx,:) = NaN;
x0 = names(missing_idx,2:3);
model = [1 10; 4 30];% Gaussian model
c = rand(3,nTasks);% use cross-variogram for the c?
itype = 1; % simple kriging
avg = rand(1, nTasks); %average value
block = rand(1,2);
nd = ones(1,2);
ival = 0; % no cross validation
nk = 5;
rad  = 10;
ntok = 2;
b = rand(3, nTasks); %never used?

[x0s,s,sv,idout,l,k,k0]=cokri(x,x0,model,c,itype,avg,block,nd,ival,nk,rad,ntok,b);

%% evaluate
err_RMSE_cokriging = zeros(nTasks,1);

for t = 1:nTasks
    err_RMSE_cokriging(t) = sqrt(norm(x0s(:,2+t) - series{t}(missing_idx,time),'fro')^2/(nMissing));
end

disp(err_RMSE_cokriging);
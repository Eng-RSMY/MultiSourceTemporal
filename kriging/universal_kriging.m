function [ X_est ] = universal_kriging( X, idx_Missing, locations)
%CO_KRIGING Summary of this function goes here
%   Detailed explanation goes here

[nLoc, nTasks ]  = size(X);
idx_Observe = setdiff(1:nLoc, idx_Missing);


x0 = locations(idx_Missing,:);
x_Observe = [locations, X];
x_Observe (idx_Missing,:) = NaN;

mod = 3; % quadratic
a = 1;
model = [mod ,a];% 

c = rand(nTasks);% use cross-variogram for the c?
itype = 5; % universal kriging
avg = mean(x_Observe(idx_Observe,3:end)); %average value
block = ones(1,2);
nd = ones(1,2);% point kriging
ival = 0; % no cross validation
nk = 10; % 10 works worst
rad  = 80; % 80 wosrt, 20 good
ntok = 1;% missing point group size
b   = 0.086*a;%never used?

[X_est]=cokri(x_Observe,x0,model,c,itype,avg,block,nd,ival,nk,rad,ntok,b);


end


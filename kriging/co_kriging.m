function [ X_est ] = co_kriging( X, idx_Missing )
%CO_KRIGING Summary of this function goes here
%   Detailed explanation goes here

missing_idx =[1:10];
observe_idx = setdiff(1:nLocs, missing_idx);

x_missing = x;
x_missing(missing_idx,:) = NaN;
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

[x0s,s,sv,idout,l,k,k0]=cokri(x_missing,x0,model,c,itype,avg,block,nd,ival,nk,rad,ntok,b);


end


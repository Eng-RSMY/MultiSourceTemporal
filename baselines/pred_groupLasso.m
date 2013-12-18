function [ x history ] = pred_groupLasso( series, nLag, lambda, index)
%PREDICT_GL Summary of this function goes here
%   Detailed explanation goes here
global verbose

nVar  = size(series{1},1);
nType = size(series,1);

rho = 0.1;
alpha = 0.1;

partition = [];
for type = 1:nType
    partition = [partition, nVar*nLag];
end
        
A = zeros(length(index{1}),nLag*nVar*nType);
T = length(index{1});
% training 

% Estimate for each location
for t = index{1}
     x = [];
    for  type = 1:nType      
        for l = 1:nLag
            x = [x , series{type}(:,t-l)'];
        end
    end
    A(t-nLag,:) = x;
end

    

b = zeros(T,1);
b = series{1}(1,index{1})';

[sol history] = group_lasso(A, b,lambda, partition, rho, alpha);

A_t = [];
for t = index{2}
    x = [];
    for type = 1:nType
        for l = 1:nLag
            x = [x ,series{type}(:,t-l)'];
        end
    end
    A_t = [A_t; x];
end
pred = A_t*sol;
true = series{1}(1, index{2})';
error = norm(true-pred);
    

end


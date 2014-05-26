% create missing data points for climate P17 
clear; clc;
load 'climateP17.mat'

nTasks = length(series);
[nLocs , nTime] = size(series{1});


%% tensor of long * lat * task
% time = 1;
% X = zeros(16,8,nTasks);
% 
% 
% for t = 1:nTasks
%     D = [series{t}(:,time);0;0;0];
%     X(:,:,t)  =  reshape(D,16,8);
% end
% 
% 
% nMissing = 10;
% idx_Missing= [[ones(1,8),1,2];[1:8,1,2]];idx_Missing = idx_Missing';
% 
% X_Missing = X;
% X_Missing(idx_Missing(:,1),idx_Missing(:,2),:) =0;

%% tensor of loc * time * task
X = zeros(nLocs, nTime, nTasks);
for t = 1:nTasks
    X(:,:,t) = series{t};
end

idx_Missing = [1:10]';
time = 1;

X_Missing = X;
X_Missing(idx_Missing(:,1),time,:) =0; 
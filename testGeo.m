clear;
load 'climateP17'

global verbose;
verbose  = 1;

% grouping the locations
nLoc = length(locations);
nBlocks =  5;
szBlock = nLoc / nBlocks;
nType = length(series);
[nLoc, nTime] = size(series{1});

numTask = nLoc * nType;
[~, center, ~, dist] = kmeans(locations, nBlocks);

clusters = cell(nBlocks,1);
for k = 1:nBlocks
    clusters{k} = [];
end
for i = 1:nLoc 
    % find the closest centroid
    [~,c_sort] = sort(dist(i,:));
    for j = c_sort
        if(length(clusters{j})<szBlock)
            clusters{j} = [clusters{j},i];
            break;
        end
    end
end
idx = size(nLoc, 1);
for k = 1:nBlocks
    idx(clusters{k}) = k;
end

%%

colors = varycolor(nBlocks);
for k = 1:nBlocks
    loc = locations(clusters{k},:);
    scatter(loc(:,1),loc(:,2),30,repmat(colors(k,:),[szBlock,1]),'fill');hold on;
end
hold off;

%%

nSample = nTime-1;
X = cell(1,numTask);
Y = cell(1,numTask);
     % construct feature and label for each task
for type = 1:nType
    agent = series{type};
    for k = 1:nBlocks
        for j = 1:szBlock
            loc = clusters{k}(j);
            task_idx= (type-1)*nLoc + (k-1)*szBlock + j;


             features = zeros(nLoc,nSample);
             labels = zeros(nSample,1);

             for sample = 1:nSample
                 features(:,sample) = agent(:,sample);
                 labels(sample) = agent(loc,sample+1);
             end

             X{task_idx} = features;
             Y{task_idx} = labels;
        end
    end
 end
if verbose
    fprintf('Data Constructed\n');
end

%%
pr = 0.4;
beta = 1e-2;
lambda = 216; 
[TrainIdx, TestIdx]  = crossvalind('HoldOut',nSample,pr);

dimModes = [nLoc, szBlock,nBlocks,nType]; 
X_train = cell(1,numTask);
Y_train = cell(1,numTask);
X_test = X_train;
Y_test = Y_train;



for i = 1:numTask
    X_train{i} = X{i}(:,TrainIdx);
    Y_train{i} = Y{i}(TrainIdx);
    X_test{i} = X{i}(:,TestIdx);
    Y_test{i} = Y{i}(TestIdx);
end

if verbose
    fprintf('Data Splitted: Training %d , Testing %d\n', 1-pr, pr);
end

%%

[ W_Convex ,~, ~ ] = MLMTL_Convex( X_train, Y_train, dimModes, beta, lambda);
[ W_Mixture ,~ ,~] = MLMTL_Mixture( X_train, Y_train, dimModes, beta, lambda);

% select best parameter

MSE_Convex = MLMTL_Test(X_test,Y_test, W_Convex);
MSE_Mixture = MLMTL_Test(X_test,Y_test, W_Mixture);

if verbose
    fprintf('Prediction MSE Convex: %d Mixture:  %d\n ',MSE_Convex,MSE_Mixture);
end



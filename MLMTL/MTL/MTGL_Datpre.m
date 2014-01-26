function [data_eval, data_test] = MTGL_Datpre(series, ratio)
global verbose;
verbose = 1;

if nargin==1
    ratio = 0.1;
end

nType = length(series);
[nLoc, nTime] = size(series{1});

numTask = nLoc * nType;
X = cell(numTask,1);
Y = cell(numTask,1);


nSample = nTime-1;
for type = 1:nType
 % construct feature and label for each task
 for loc = 1:nLoc
     task_idx = (type-1)*nLoc + loc;
     features = zeros(nLoc,nSample);
     labels = zeros(nSample,1);

     for sample = 1:nSample
         features(:,sample) = series{type}(:,sample);
         labels(sample) = series{type}(loc,sample+1);
     end

     X{task_idx} = features';
     Y{task_idx} = labels;
 end
end
%%


[TrainIdx, TestIdx]  = crossvalind('HoldOut',nSample,ratio);
X_train = cell(1,numTask);
Y_train = cell(1,numTask);
X_test = X_train;
Y_test = Y_train;



for i = 1:numTask
    X_train{i} = X{i}(TrainIdx,:);
    Y_train{i} = Y{i}(TrainIdx);
    X_test{i} = X{i}(TestIdx,:);
    Y_test{i} = Y{i}(TestIdx);
end


data_eval.X = X_train;
data_eval.Y = Y_train;
data_test.X = X_test;
data_test.Y = Y_test;

end
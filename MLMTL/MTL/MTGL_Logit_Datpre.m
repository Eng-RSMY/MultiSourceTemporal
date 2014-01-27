function [Dat_eval , Dat_test] = MTGL_Logit_Datpre(series,label, ratio)
%MTGL_DATPRE_LOGIT Summary of this function goes here
%   Detailed explanation goes here


[nChannel, nTime, nTrial] = size(series);

nSample = nTrial;
nTasks = nChannel;
X = cell (1, nTasks);
Y = cell (1, nTasks);



for t = 1: nTasks
    X{t} = squeeze(series(t,:,:))';
    Y{t} = label;
end





[TrainIdx, TestIdx]  = crossvalind('HoldOut',nSample,ratio);
X_train = cell(1,nTasks);
Y_train = cell(1,nTasks);
X_test = X_train;
Y_test = Y_train;



for i = 1:nTasks
    X_train{i} = X{i}(TrainIdx,:);
    Y_train{i} = Y{i}(TrainIdx);
    X_test{i} = X{i}(TestIdx,:);
    Y_test{i} = Y{i}(TestIdx);
end


Dat_eval.X = X_train;
Dat_eval.Y = Y_train;
Dat_test.X = X_test;
Dat_test.Y = Y_test;
end


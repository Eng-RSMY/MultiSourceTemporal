function [ output_args ] = MLMTL_Logit_Datpre( input_args )
%MLMTL_LOGIT_DATPRE Summary of this function goes here
%   Detailed explanation goes here
clear;
clc;
addpath(genpath('~/Documents/MATLAB/MultiSourceTemporal'))
global verbose;
verbose =1;

load 'eeg_small';
[nChannel, nTime, nTrial] = size(series);

nSample = nTrial;
nTasks = nChannel;
X = cell (1, nTasks);
Y = cell (1, nTasks);
dimModes = [nTime, 4,4];
beta = 1e-2;
lambda_Cvx = 1e-8;
lambda_Mix = 1e-5;


for t = 1: nTasks
    X{t} = squeeze(series(t,:,:));
    Y{t} = label;
end
fprintf('Data Constructed\n');

r_Cvx = [];
r_Mix = [];

for pr = fliplr(0.1:0.1:0.5)

[TrainIdx, TestIdx]  = crossvalind('HoldOut',nSample,pr);
X_train = cell(1,nTasks);
Y_train = cell(1,nTasks);
X_test = X_train;
Y_test = Y_train;



for i = 1:nTasks
    X_train{i} = X{i}(:,TrainIdx);
    Y_train{i} = Y{i}(TrainIdx);
    X_test{i} = X{i}(:,TestIdx);
    Y_test{i} = Y{i}(TestIdx);
end

end


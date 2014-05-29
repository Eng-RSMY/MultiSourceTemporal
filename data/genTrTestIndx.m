% Generates training and testing time stamps
clc
clear

load climateP17.mat

T = size(series{1}, 2);

nLag = 3;

indexes = nLag+1:T;

tTrain = 120;
tTest = 33;

N = 10;
trainTs = zeros(tTrain, N);
testTs = zeros(tTest, N);

for i = 1:N
    in = randperm(length(indexes));
    trainTs(:, i) = in(1:tTrain)';
    testTs(:, i) = in(1:tTest)';
end

save('climateP17_trtsIdx.mat', 'trainTs', 'testTs')
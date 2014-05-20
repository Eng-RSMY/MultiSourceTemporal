nTasks = 3;
nSamples = 10;
nLocs= 5;
beta = 0.5;
X = cell(nTasks, 1);
for t = 1: nTasks
    X{t} = rand([nSamples,nLocs]);
end
Dims = [nLocs,nLocs ,nTasks];
W = para_kriging(X, beta, Dims);
    
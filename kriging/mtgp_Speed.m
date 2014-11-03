% Run Speed
addpath(genpath('../'))
addpath('../data/Foursquare/')

name = 'climateP17.mat';
name2 = 'climateP17_missIdx';

tic
run('runMTGP_Once')
timeP17 = toc;
disp(timeP17)

name = 'climateP3.mat';
name2 = 'climateP3_missIdx.mat';

tic
run('runMTGP_Once')
timeP3 = toc;
disp(timeP3)

name = 'tensor.mat';
name2 = 'fsq_missIdx.mat';

tic
run('runMTGP_Once')
time4sq = toc;
disp(time4sq)

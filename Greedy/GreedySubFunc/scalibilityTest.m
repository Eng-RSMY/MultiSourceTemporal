% Test scalability of the algorithms

dim = floor(logspace(1, 4, 7));
timeMine = 0*dim;
timeEigs = 0*dim;
for i = 1:length(dim)
    X = randn(dim(i), 2*dim(i));
    P = X*X';
    tic
    approxEV(P, 1e-4);
    timeMine(i) = toc;
    tic
    eigs(P, 1);
    timeEigs(i) = toc;
end

hold all
loglog(dim, timeMine)
loglog(dim, timeEigs)
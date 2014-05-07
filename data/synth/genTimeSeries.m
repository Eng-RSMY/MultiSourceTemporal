nTasks = 10;
maxIter = 10;
te_sz = 100;
tr_szs = [10,50,100,200];
v_sz = 100;
rnk = 3;
p = 20;
% T = 300;
sig = 0.5;

for iter = 1:maxIter
    for tr_sz = tr_szs
        A_1 = randn(p, rnk)*randn(rnk, p);
        sig1 = svds(A_1, 1);
        A_1 = A_1/(sig1*1.2);


        % nTasks = 3;
        A = zeros(p,p, nTasks);
        epsilon = 1e-4;
        for j = 1:nTasks
            A(:,:,j) = A_1 +epsilon*randn(p);
            sig1 = svds(squeeze(A(:,:,j)), 1);
            A(:,:,j) = A(:,:,j)/(sig1*1.05);

        end
        te_series = tsGen(A,te_sz);
        v_series = tsGen(A,v_sz);
        tr_series = tsGen(A,tr_sz);
        fname = strcat('./data/synth/datasets3/synth',int2str(tr_sz),'_',int2str(iter),'.mat');
        save(fname,'te_series','v_series','tr_series','A');

    end
    
end


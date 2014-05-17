nTasks = 10;
maxIter = 5;
te_sz = 100;
% tr_szs = [10,50,100,200];
tr_sz = 50;
v_sz = 100;
% rnk = 3;
ranks = [1:5];
p = 20;
% T = 300;
sig = 0.2;
path = './data/synth/datasets5/synth_rk';

for iter = 1:maxIter
    for rnk = ranks
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
        fname = strcat(path,int2str(rnk),'_',int2str(iter),'.mat');
        save(fname,'te_series','v_series','tr_series','A');

    end
    
end


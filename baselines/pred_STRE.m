function [ Y_pred,A,C norm_err ] = pred_STRE( series, index )
% STRE model : refer to Cressie JASA 2011
% model:  Y[N,T] , X[K,1] 
% Y = CX + R
% X = AX + Q
global verbose;
time1=cputime;


Y1 = series{1}(1:20,index{1});
N1 = size(Y1,1);
K = 30;
max_iter = 50;
sigma2_R = 0.5; sigma2_Q = 0.1;

A_ini = randn(K,K);
C_ini = randn(N1,K);
R_ini = eye(N1,N1)*sigma2_R;
Q_ini = eye(K,K)*sigma2_Q;
pi1_ini = zeros(K,1);
V1_ini = eye(K)* 10;


%training

[A, C, Q, R, pi1, V1, LL] =  learn_kalman( ...
        Y1, A_ini, C_ini, Q_ini, R_ini, pi1_ini, V1_ini, max_iter);

 
%testing
Y2 = series{1}(1:10,index{2});
[N2, T2 ] = size(Y2);
Y_pred = zeros(N2,T2);
X  = zeros(K,T2);
X(:,1) = mvnrnd(zeros(1,K),V1_ini);
Y_pred(:,1 ) = C * X(:,1) + mvnrnd(zeros(1,N2),eye(N2,N2)*sigma2_R)';
for t = 2:T2
    X(:,t) = A* X(:,t-1) + mvnrnd(zeros(1,K),eye(K,K)*sigma2_Q)';
    Y_pred(:,t) = C * X(:,t) + mvnrnd(zeros(1,N2),eye(N2,N2)*sigma2_R)';
end
norm_err = norm(Y2-Y_pred, 'fro')/N2/T2;


    

%testing
time2 = cputime;
run_time = time2-time1;

if verbose
    fprintf('running time %d\n', run_time);
end
end


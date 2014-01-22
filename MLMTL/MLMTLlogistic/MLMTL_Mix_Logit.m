function [ W ,tensorW ] = MLMTL_Mix_Logit( X, Y, dimModes,beta, lambda  )
%MLMTL_MIX_LOGIT Summary of this function goes here
%   Detailed explanation goes here

outerNiT=1000;

if nargin>5 && ~isempty(outerNiTPre)
    outerNiT=outerNiTPre;
end

threshold = 10e-5;
if nargin>6 && ~isempty(thresholdPre)
    threshold=thresholdPre;
end

nTotalTasks=length(Y);
nAttrs=getNAttrs(X);
nModes=length(dimModes);

innerNiT = 2*nModes;

if nargin>7 && ~isempty(innerNiTPre)
    innerNiT = innerNiTPre;
end

if nTotalTasks~=prod(dimModes(2:end))
    [nTotalTasks prod(dimModes(2:end))]
    error('There are inconsistencies between the dimModes and the number of tasks.');
end

XX_plus_betaNI=cell(1,nTotalTasks);
XY=cell(1,nTotalTasks);
for t=1:nTotalTasks
    if isempty(X{t})
        XX_plus_betaNI{t}=beta*eye(nAttrs);
        XY{t}=0;
    else
        XX_plus_betaNI{t}=1/lambda*(X{t}*X{t}')+beta*eye(nAttrs); % remove nMode
        XY{t}=X{t}*Y{t};
    end
end

% A=cell(1,nModes);
A = tenzeros(dimModes);
B = cell(1,nModes);
for n=1:nModes
%     A{n}=tenzeros(dimModes);
    B{n}=tenzeros(dimModes);
end
% sumA=tenzeros(dimModes); 
sumB=tenzeros(dimModes); 

oldW=Inf(nAttrs, nTotalTasks);
oit=0;

oldL =0;
Ls = [];
W0 = tenzeros(dimModes);

while true  
%     fprintf('Iter # %d\n',oit);
    oit=oit+1;
    % Optimizing over W
    matSumAux=tenmat(A, 1) + beta/nModes*tenmat(sumB, 1);
    matSumAux=matSumAux.data;
%     matW=zeros(nAttrs, nTotalTasks);
%     for t=1:nTotalTasks
%         matW(:,t)=(XX_plus_betaNI{t})\(1/lambda*XY{t} + matSumAux(:,t));
%     end
%     W=tensor(reshape(matW, dimModes));
% 

      [~,W]  = newton_raphson(X,Y, W0, matSumAux, beta/nModes, threshold);

%     sumA=tenzeros(dimModes); 
    
    % ADD iteration over NModes
    for iter = 1: innerNiT
        
         
        for n=1:nModes
    %         [oit n]
            % Optimizing over B
            matW=tenmat(W, n);
            matW=matW.data;
            matA=tenmat(A,n);
            matA=matA.data;
    %         matB=shrink(matW-1/beta*matA, 1/beta);
            sumNB = sumB-B{n};
            matsumNB = tenmat(sumNB,n);
            matsumNB = matsumNB.data;
            shrink_target = nModes*matW - 1/beta*nModes*matA - matsumNB;
            matB = shrink(shrink_target,nModes^2/beta);

            BTensor=tensor(reshape(matB, [dimModes(n), dimModes(1:n-1), dimModes(n+1:end)]));
            B{n}=permute(BTensor, [2:n, 1, n+1:nModes]);
            sumB = sumNB+B{n};

        end
        
        
    end
    % Optimizing over A (C in the supp)
    A=A-beta*(W-1/nModes*sumB);
   
    
    Wmat=tenmat(full(W), 1);
    Wmat=Wmat.data;

    if oit>outerNiT %norm(Wmat(1:end)-oldW(1:end))<threshold
        break
    end
       
%     L = MLMTL_Objfunc(X,Y,W,B,A,lambda,beta);
%     Ls = [Ls,L];
    
%     if( abs(L-oldL)< threshold)
    if((norm(Wmat(1:end)-oldW(1:end)) < threshold)&& (verbose))
        fprintf('MLMTL_Mix_Logit:Converge after %d iteration \n', oit);
        break;
    end
    oldW=Wmat;
%     oldL = L;
          
end

% plot(Ls);


for i=1:nModes
    mat=tenmat(W, i);
    [u l v]=mySVD(mat.data);
    max(diag(l));
end

tensorW=W;
W=tenmat(full(W), 1);
W=W.data;

end


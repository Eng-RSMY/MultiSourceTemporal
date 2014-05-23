function [covari] = covsrt(npc,ma,ia,mfit,covari)
%
% Expand in storage the covariance matrix covari, so as to take into
% account parameters that are being held fixed. (For the latter,
% return zero covariances).

% Initialisation

  for i=mfit+1:ma
    for j=1:i
      covari(i,j)=0;
      covari(j,i)=0;
   end
  end

% Calcul

  k=mfit;
  for j=ma:-1:1
    if(ia(j)~=0)
      for i=1:ma
        swap=covari(i,k);
        covari(i,k)=covari(i,j);
        covari(i,j)=swap;
      end
      for i=1:ma
        swap=covari(k,i);
        covari(k,i)=covari(j,i);
        covari(j,i)=swap;
      end
      k=k-1;
    end
  end

  return


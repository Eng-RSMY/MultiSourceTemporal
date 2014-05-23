function [alpha,beta,chisq] = mrqcof(x,y,sig,ndata,a,ia,ma,nalp,funcs,model)
%
% Used by mrqmin to evaluate the linearized fitting matrix alpha,
% and vector beta as in 15.5.8 (Numerical Recipies), and calculate X².

% Initialisation

  mfit=0;
  for j=1:ma
    if (ia(j)~=0), mfit=mfit+1; end
  end

  for j=1:mfit
    for k=1:j
      alpha(j,k)=0;
    end
    beta(j)=0;
  end

  chisq=0;

% Calcul

  for i=1:ndata
    eval(['[ymod,dyda] = ' funcs '(model,x(i),a(1),a(3),a(2));'])
    sig2i=1/(sig(i)*sig(i));
    dy=y(i)-ymod;
    j=0;
    for l=1:ma
      if(ia(l)~=0)
        j=j+1;
        wt=dyda(l)*sig2i;
        k=0;
        for m=1:l
          if(ia(m)~=0)
            k=k+1;
            alpha(j,k)=alpha(j,k)+wt*dyda(m);
          end
        end
        beta(j)=beta(j)+dy*wt;
      end
    end
    chisq=chisq+dy*dy*sig2i;
  end

  for j=2:mfit
    for k=1:j-1
      alpha(k,j)=alpha(j,k);
    end
  end

  return
  

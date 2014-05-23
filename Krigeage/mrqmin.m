function [covari,alpha,chisq,alamda,a] = mrqmin(x,y,sig,ndata,a,ia,ma,nca,funcs,alamda,model)
%
% USES covsrt, gaussj, mrqcof
%
% Levenberg- Marquardt method, attempting to reduce the value X² 
% of a fit between a set of data points x(1:ndata), y(1:ndata) 
% with standard deviations sig(1:ndata), and a nonlinear function
% dependent on ma coefficients a(1:ma). The input array ia(1:ma)
% indicates by nonzero entries those components of a that should
% be fitted for, and by zero entries those components that should
% be held fixed at their input value. The program returns current
% best-fit values for parameters a(1:ma), and X²=chisq. The arrays
% covar(1:nca,1:nca), alpha(1:nca,1:nca) with physical dimension
% nca (>= the numbre of fitted parameters) are used as working space
% during most iterations. Supply a subroutine funcs(x,a,yfit,dyda,ma)
% that evaluates fitting function yfit, and its derivatives dyda with
% respect to the fitting parameters a at x. On the fist call provide
% an initial guess for the parameters a, and set alamda<0 for
% initialization (which then sets alamda=0.001). If a step suceeds
% chisq becomes smaller and alamda decreases by a factors of 10. if
% a step fails alamda grows by a factor of 10. You must call this
% routine repeatedly until convergence is achieved. then, make one
% final call with alamda=0, so that covari(1:ma,1:ma) returns the 
% covariance matrix, and alpha the curvature matrix. (Parameters 
% held fixed will return zero covariances.)

covari = [];
alpha  = [];
chisq  = [];

% Pour alamda < 0

  if(alamda<0)
    mfit=0;
    for j=1:ma
      if (ia(j)~=0), mfit=mfit+1; end
    end
    alamda=0.001;
    [alpha,beta,chisq] = mrqcof(x,y,sig,ndata,a,ia,ma,nca,funcs,model);
    if a(2) < 0, return, end
    ochisq=chisq;
    for j=1:ma
      atry(j)=a(j);
    end
  da = 0;
  save mrqminv ochisq atry beta da mfit alpha
  end

% Pour alamda > 0 

  if(alamda>=0), load mrqminv, end
  for j=1:mfit
    for k=1:mfit
      covari(j,k)=alpha(j,k);
    end
    covari(j,j)=alpha(j,j)*(1.+alamda);
    da(j)=beta(j);
  end
  [covari,da] = gaussj(covari,mfit,nca,da',1,1);

  if(alamda==0)
    [covari]  = covsrt(nca,ma,ia,mfit,covari);
    return
  end

  j=0;

  for l=1:ma
    if(ia(l)~=0)
      j=j+1;
      atry(l)=a(l)+da(j);
    end
  end

  [covari,da,chisq] = mrqcof(x,y,sig,ndata,atry,ia,ma,nca,funcs,model);

  if(chisq<ochisq)
    alamda=0.1*alamda;
    ochisq=chisq;
    for j=1:mfit
      for k=1:mfit
        alpha(j,k)=covari(j,k);
      end
      beta(j)=da(j);
    end
    for l=1:ma
      a(l)=atry(l);
    end
  else
    alamda=10.*alamda;
    chisq=ochisq;
  end

% Save local variables

  save mrqminv ochisq atry beta da mfit alpha

  return
  

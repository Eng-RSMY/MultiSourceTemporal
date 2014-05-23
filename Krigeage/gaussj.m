function [a,b] = gaussj(a,n,np,b,m,mp)
%
% Linear equation solution by Gauss-Jordan elimination, equation (2.1.1)
% Numerical Recipies. a(1:n,1:n) is an input matrix stored in an array of
% physical dimensions np by np. b(1:n,1:m) is an input matrix containing
% the m right-hand side vectors, stored in an array of physical dimensions
% np by mp. On output, a(1:n,1:n) is replaced by its matrix inverse, and
% b(1:n,1:m) is replaced by the corresponding set of solution vectors.
% Parameter NMAX is the largest anticipated value of n.

% Initialisation

  for j=1:n
    ipiv(j)=0;
  end

% Calcul

  for i=1:n
  big=0;
  for j=1:n
    if(ipiv(j)~=1)
      for k=1:n
      if (ipiv(k)==0)
        if (abs(a(j,k))>=big)
           big=abs(a(j,k));
           irow=j;
           icol=k;
         end
       elseif (ipiv(k)>1)
         pause, dips('singular matrix in gaussj')
       end
       end
     end
  end

  ipiv(icol)=ipiv(icol)+1;
  if (irow~=icol)
    for l=1:n
      dum=a(irow,l);
      a(irow,l)=a(icol,l);
      a(icol,l)=dum;
    end
    for l=1:m
      dum=b(irow,l);
      b(irow,l)=b(icol,l);
      b(icol,l)=dum;
    end
  end

  indxr(i)=irow;
  indxc(i)=icol;
  if (a(icol,icol)==0), pause, disp('singular matrix in gaussj'), end
  pivinv=1/a(icol,icol);
  a(icol,icol)=1;

  for l=1:n
    a(icol,l)=a(icol,l)*pivinv;
  end

  for l=1:m
    b(icol,l)=b(icol,l)*pivinv;
  end

  for ll=1:n
    if(ll~=icol)
      dum=a(ll,icol);
      a(ll,icol)=0;
      for l=1:n
        a(ll,l)=a(ll,l)-a(icol,l)*dum;
      end
      for l=1:m
        b(ll,l)=b(ll,l)-b(icol,l)*dum;
      end
    end
  end
  end

  for l=n:-1:1
   if(indxr(l)~=indxc(l))
   for k=1:n
     dum=a(k,indxr(l));
     a(k,indxr(l))=a(k,indxc(l));
     a(k,indxc(l))=dum;
   end
   end
  end

  return

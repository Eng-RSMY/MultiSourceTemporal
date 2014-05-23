function [np, gam, hm, tm, hv, tv] = vario2dr ( nlag, nx, ny, ndir,...
         ixd, iyd, vr, nvarg, ivtail, ivhead, ivtype, nvar )
%
%
%      vario2dr : matlab m-file
%      gam2     : fortran mex-file (corresponds to gam2 in GSLIB)
%      gam2g    : fortran gateway function
%
%                Variogram of Data on a 2-D regular Grid
%                ***************************************
%
% This subroutine computes any of eight different measures of spatial
% continuity for regular spaced 2-D data.  Missing values are allowed
% and the grid need not be square. From the GSLIB library.; see
%
%     Deutsch, C.V. and A.G. Journel (1992). 
%     GSLIB: Geostatistical Software Library and User's Guide.
%     Oxford University Press, Oxford, 340 p.
%
%
%
% INPUT VARIABLES:
%
%   nlag             Number of lags to calculate
%   nx               Number of units in x
%   ny               Number of units in y
%   ndir             Number of directions to consider
%   ixd(ndir)        X indicator of direction - number of X grid columns
%                      that must be shifted to move from a node on the
%                      grid to the next nearest node on the grid which
%                      lies on the directional vector.
%   iyd(ndir)        Y indicator of direction - similar to ixd, number
%                      of grid lines that must be shifted to nearest
%                      node which lies on the directional vector
%   nv               The number of variables
%   vr(nx,ny,nv)     Three dimensional array of data in GSLIB. There
%                    are no 3-D matrices in MATLAB ==> we fool both
%                    Matlab and Fortran by "stacking" nv 2-array.
%   tmin,tmax        Trimming limits
%   nvarg            Number of variograms to compute
%   ivtail(nvarg)    Variable for the tail of each variogram
%   ivhead(nvarg)    Variable for the head of each variogram
%   ivtype(nvarg)    Type of variogram to compute:
%                      1. semivariogram
%                      2. cross-semivariogram
%                      3. covariance
%                      4. correlogram
%                      5. general relative semivariogram
%                      6. pairwise relative semivariogram
%                      7. semivariogram of logarithms
%                      8. rodogram
%                      9. madogram
%                     10. indicator semivariogram: an indicator variable
%                         is constructed in the main program.
%   nvar	     Number of variables
%
% OUTPUT VARIABLES:  
%
%   np()             Number of pairs
%   gam()            semivariogram, covariance, correlogram,... value
%   hm()             Mean of the tail data
%   tm()             Mean of the head data
%   hv()             Variance of the tail data
%   tv()             Variance of the head data
%

%   INPUT VARIABLES

tmin = -1e021;
tmax = +1e021;

%   VARIOGRAMME

  [np,gam,hm,tm,hv,tv] =... 
		gam2 (nlag,nx,ny,ndir,ixd,iyd,vr,tmin,tmax,...
		       nvarg,ivtail,ivhead,ivtype,nvar);

%   OUTPUT VARIABLES

[np, gam, hm, tm, hv, tv] = outvario(nlag,0,ndir,nvarg,np,gam,hm,tm,hv,tv,ivtype);


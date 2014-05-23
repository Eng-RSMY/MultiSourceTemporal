function [np, gam, hm, tm, hv, tv] = vario3dr( ...
          nlag, nx, ny, nz, ndir, ixd, iyd, izd, vr, ...
          nvarg, ivtail, ivhead, ivtype, nvar)
%
%      vario3dr : matlab m-file
%      gam3     : fortran mex-file (corresponds to gam3 in GSLIB)
%      gam3g    : fortran gateway function
%
%                Variogram of Data on a 3-D Regular Grid
%                ***************************************
%
% This subroutine computes any of eight different measures of spatial
% continuity for regular spaced 3-D data.  Missing values are allowed
% and the grid need not be cubic.
%
%
%
% INPUT VARIABLES:
%
%   nlag             Maximum number of lags to be calculated
%   nx               Number of units in x (number of columns)
%   ny               Number of units in y (number of lines)
%   nz               Number of units in z (number of levels)
%   ndir             Number of directions to consider
%   ixd(ndir)        X (column) indicator of direction - number of grid
%                      columns that must be shifted to move from a node
%                      on the grid to the next nearest node on the grid
%                      which lies on the directional vector
%   iyd(ndir)        Y (line) indicator of direction - similar to ixd,
%                      number of grid lines that must be shifted to
%                      nearest node which lies on the directional vector
%   izd(ndir)        Z (level) indicator of direction - similar to ixd,
%                      number of grid levels that must be shifted to
%                      nearest node of directional vector
%   nv               The number of variables
%   vr(nx,ny,nz,nv)  Four dimensional array of data
%   tmin,tmax        Trimming limits
%   nvarg            Number of variograms to compute
%   ivtail(nvarg)    Variable for the tail of the variogram
%   ivhead(nvarg)    Variable for the head of the variogram
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
%   nvar             Number of variables
%
% OUTPUT VARIABLES:  
%
%   np()             Number of pairs
%   gam()            Semivariogram, covariance, correlogram,... value
%   hm()             Mean of the tail data
%   tm()             Mean of the head data
%   hv()             Variance of the tail data
%   tv()             Variance of the head data
%

%   INPUT VARIABLES

tmin = -1e21;
tmax = +1e21;

%   VARIOGRAMME

 [np, gam, hm, tm, hv, tv] = gam3 (nlag, nx, ny, nz, ndir, ... 
	ixd, iyd, izd, vr, tmin, tmax, nvarg, ivtail, ivhead, ivtype, nvar);

%   OUTPUT VARIABLES

[np, gam, hm, tm, hv, tv] = outvario(nlag,0,ndir,nvarg,np,gam,hm,tm,hv,tv,ivtype);


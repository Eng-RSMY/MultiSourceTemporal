%
% 		MATLAB Kriging Toolbox
%	      (version 3.0: février 1998)
%-------------------------------------------------------
%
% VARIOGRAMS or STRUCTURE FUNCTIONS:
%
% vario2dr : variogram(s) of regularly spaced 2-D data
% vario2di : variogram(s) of irregularly spaced 2-D data
% vario3dr : variogram(s) of regularly spaced 3-D data
% vario3di : variogram(s) of irregularly spaced 3-D data
% var2diuv : variogram(s) of irregularly spaced 2-D vectors
%
%   Variograms and correlograms: see the book by
%   Deutsch and Journel (1992). Oxford University Press.
%   The five (5) variogram functions: vario2dr, vario2di,
%   var2diuv, vario3dr and vario3di are m-files calling the
%   MEX-files of GSLIB subroutines: GAM2.for, GAMV2.for,
%   GAMV2UV.for, GAM3.for and GAMV3.for.
%
% CONFIDENCE INTERVALS
%
% confint  : confidence intervals for the structure function
% 
% FITTING VARIOGRAMS: 
%
% fitvario : variogram least-square fitting (with optimization toolbox)
% fitvari2 : variogram least-square fitting (without optimization toolbox)
% fun      : function used by 'fitvario' to compute the fonction
%            'variogr'
% mrqmin   : least-square fitting: Levenberg-Marquardt method
% variogr  : computes a set of theoretical correlograms and 
%            semi-variograms
% variogr2 : variogr for use with fitvari2
%
% KRIGING - COKRIGING (Marcotte, 1991)
%
% cokri    : performs point or block cokriging in D dimensions
% cokri2   : called from cokri; modified for new variograms
% means    : similar to mean.m
% trans    : called from cokri2
%
% KRIGING (Davis)
%
% davis    : punctual Kriging: Davis' method
%
% FILTERING (Barnes)
%
% barnes   : makes use of kringing to filter kriged data 
% filresp  : filter response in the wavelength domain
% tintore  : filter gridded data using tintore's parameters	
%
% ASSOCIATED FUNCTION
%
% covsrt   : transform the covariance matrix of mrqmin
% déplie   : transform a vector into a matrix
% gaussj   : linear equation solution by Gauss-Jordan elimination
% kregrid  : creates a mx2 matrix of all the grid coordinates
% kregrid3 : matrix (m x 3) of 3-D grid coordinates
% ksone    : MEX-file of the normality test 
% kstest   : Kolmogorov-Smirnov normality test
% mat3dp   : pseudo 3-D matrix
% mat4dp   : pseudo 4-D matrix
% mrqcof   : used by mrqmin
% outvario : organization of variogram output variables
% 
% DOCUMENTS
%
% francais.doc: french documentation
% english.doc : english documentation
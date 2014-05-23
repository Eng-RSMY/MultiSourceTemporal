function r = mat4d (mat, d3, d4, ii, jj, kk, ll)
%
%
%	r = mat4d (mat, d3, d4, ii, jj, kk, ll)
% 
%   gets the coordinates of the mat(ii,jj,kk,ll) entry in 
%   the pseudo-4D matrice "mat"
%
[d1,d2] = size(mat);
m = ii + ( (kk-1) * d1/d3/d4 ) + ( (ll-1) * d1/d4 );
n = jj;
r = mat(m,n);
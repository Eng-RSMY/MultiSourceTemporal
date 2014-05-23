function r = mat3d ( mat, d3, ii, jj, kk )
%
%
%       r = mat3d ( mat, d3, i, j, k )
%
%
%   gets the point of the mat(ii,jj,kk) entry in
%   the pseudo-3D matrice "mat"
%
[d1, d2] = size(mat);
m = ii + ( (kk-1) * d1 / d3 );
n = jj;
r = mat(m,n);
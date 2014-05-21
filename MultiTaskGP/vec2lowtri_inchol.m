%
% irank: intrinsic rank
%
% converts the column  vector v into an incomplete lower triangular matrix
% of dimensions DxD.
% D = (-1 + sqrt(8*length(v)+1))/2;
% fills D row-wisely
function L = vec2lowtri_inchol(v,D,irank)
%D = (-1 + sqrt(8*length(v)+1))/2;
L = zeros(D);
%low = 1;
%for i = 1 : D
%  up = low + i - 1;
%  L(i,1:i) = v(low:up);
%  low = up + 1;
%end

low = 1;
for i = 1 : D
  up = min(irank,i);
  L(i,1:up) = v(low:low+up-1);
  low = low + up;
end




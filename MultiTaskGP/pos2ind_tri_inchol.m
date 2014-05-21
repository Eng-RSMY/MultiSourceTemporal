% 
% irank: the instrinc rank
%
% translates a position of a vector that 
% reads a triangual matrix row-wisely
% into  an index (i,j) of the matrix
function [i j] = pos2ind_tri_inchol(pos,D,irank)
i = 0;
s(1) = 0;
j = 1;
while (s < pos)
  i = i + 1;
  s(i+1) = s(i) + min(i,irank);
end

if (i > 0)
  j = pos - s(i);
end


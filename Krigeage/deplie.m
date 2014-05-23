function mat = deplie(y, nx, ny)
%
% 	mat = deplie (y, nx, ny)
%
% Fonction qui permet de convertir un vecteur 'y' en une 
% matrice selon les dimensions sp�cifi�es par 'nx' et 'ny'.
%

% V�rification

  [l,n] = size(y);
  
  if n > 1, y = y'; [l,n] = size(y); end

  if nx*ny ~= l
     error(['Length(y) must be equal to nx*ny'])
  end

% D�pliage

  mat=zeros(ny,nx);
  k = 1;

   for i = 1:ny
     mat(i, 1:nx) = y( k: k+nx-1 )';
     k = k + nx;
  end

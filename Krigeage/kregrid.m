function [y,nx,ny] = kregrid(x0,dx,xf,y0,dy,yf)
%
%
%    y = kregrid(x0,dx,xf,y0,dy,yf)
%
%    Creates a (m x 2) matrix of all the coordinates
%    of the grid.
%
%
nx = (xf - x0) / dx + 1;
ny = (yf - y0) / dy + 1;
fin = nx*ny;
y = zeros(fin,2);
x0 = [x0:dx:xf]';
ynx = ones(nx,1);
%
k = 1;
for ys=y0:dy:yf
   y(k:k+nx-1,2)=ys*ynx;
   y(k:k+nx-1,1)=x0;
   k = k + nx;
end


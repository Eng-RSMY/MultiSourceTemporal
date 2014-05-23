function [y,nx,ny,nz] = kregrid(x0,dx,xf,y0,dy,yf,z0,dz,zf)
%
%
%    y = kregrid(x0,dx,xf,y0,dy,yf,z0,dz,zf)
%
%    Creates a (m x 2) matrix of all the coordinates
%    of the 3D grid.
%
%
nx = (xf - x0) / dx + 1;
ny = (yf - y0) / dy + 1;
nz = (zf - z0) / dz + 1;

fin = nx*ny*nz;
y = zeros(fin,3);
x0 = [x0:dx:xf]';
z0 = [z0:dz:zf];
ynx = ones(nx,1);
%
k = 1;
for i=1:length(z0)
for ys=y0:dy:yf
   y(k:k+nx-1,2)=ys*ynx;
   y(k:k+nx-1,1)=x0;
   y(k:k+nx-1,3)=z0(i)*ones(length(x0),1);
   k = k + nx;
end
end

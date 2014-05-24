function [ kout ] = mlkernel( K, locs, newloc )
%MLKERNEL Summary of this function goes here
%   Detailed explanation goes here

[n d] = size(locs);
Mx = zeros(d);
for i = 1:n
    for j = 1:n
        Mx = Mx+ (locs(i,:)-locs(j,:))'*(locs(i,:)-locs(j,:));
    end
end

Qx = zeros(d);
for i = 1:n
    for j = 1:n
        Qx = Qx +(locs(i,:)-locs(j,:))'*(locs(i,:)-locs(j,:))*K(i,j);
    end
end
A = Qx\Mx/Mx;

m = size(newloc);
for i = 1:m
    tmp = locs-repmat(newloc(i,:),[n,1]);
    kout(:,i) = diag(tmp*A*tmp');
end


end


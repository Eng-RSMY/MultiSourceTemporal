function [ latent_rank ,SVs] = cal_LatentRank( W , thres )
%CAL_LATENTRANK Summary of this function goes here
%   Detailed explanation goes here
W_tensor = fld(W,1,10);
r = 0;
SVs = [];
for i  = 1:3
[U S V] = svd(unfld(W_tensor,i));
r = r + sum(diag(S>thres));
SVs = [ SVs,diag(S)'];
end

latent_rank = r/3;


end



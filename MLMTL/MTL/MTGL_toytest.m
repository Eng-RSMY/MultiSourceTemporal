clear;clc;
r = 3;
q = 4;
p = 5;
series = cell(1,r);
for i = 1:r
    series{i} = rand(q,p);
end
[ W_tensor ] = MTGL( series,'L211');
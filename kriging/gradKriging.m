function [obj, G , Gb] = gradKriging(series, dist, Sol, b, index)
%GRADKRIGING Summary of this function goes here
%   Detailed explanation goes here
funcList = {@gradGaussian, @gradGumbel, @gradLogistic};
nType = length(series);
nVar = size(series{1}, 1);
nLag = size(Sol, 2)/nVar;

obj = 0;
G = 0*Sol;
S = cell(nLag, 1);

for i = 1:nType
    for ll = 1:nLag
        S{ll} = Sol(nVar*(i-1)+1:nVar*i, nVar*(ll-1)+1:nVar*ll);
    end
 
    [objTemp, Gtemp, Gbtemp] = feval(funcList{i}, series{i}, S, b(nVar*(i-1)+1:nVar*i), index);
    obj = obj + objTemp;
    Gb(nVar*(i-1)+1:nVar*i) = Gbtemp;
    for ll = 1:nLag
        G(nVar*(i-1)+1:nVar*i, nVar*(ll-1)+1:nVar*ll) = Gtemp{ll};
    end
end

% the spatio-covariance

for i = 1:nType
    for j = 1:nType
         S{ll} = Sol(nVar*(i-1)+1:nVar*i, nVar*(ll-1)+1:nVar*ll);
    end
end

end


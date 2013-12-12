function [obj, G, Gb] = gradCoRegS(series, Sol, b, index)
funcList = {@gradGaussian, @gradGumbel, @gradLogistic};
nType = length(series);
nVar = size(series{1}, 1);
nLag = size(Sol, 2)/nVar;
obj = 0;
G = 0*Sol;
Gb = 0*b;
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
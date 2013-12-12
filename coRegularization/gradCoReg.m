function [obj, G] = gradCoReg(series, Sol, lambda, index)
funcList = {@gradGaussian, @gradGumbel, @gradLogistic};
nType = length(series);
nVar = size(series{1}, 1);
nLag = size(Sol, 2)/nVar;
obj = 0;
G = 0*Sol;
b = zeros(nVar, 1);
S = cell(nLag, 1);
for i = 1:nType
    for ll = 1:nLag
        S{ll} = Sol(nVar*(i-1)+1:nVar*i, nVar*(ll-1)+1:nVar*ll);
    end
    [objTemp, Gtemp] = feval(funcList{i}, series{i}, S, b, index);
    obj = obj + objTemp;
    for ll = 1:nLag
        G(nVar*(i-1)+1:nVar*i, nVar*(ll-1)+1:nVar*ll) = Gtemp{ll};
    end
end

% The coRegularization part
for i = 1:nType
    for j = 1:nType
        if i ~= j
            obj = obj + lambda * norm(Sol(nVar*(i-1)+1:nVar*i, :) -...
                Sol(nVar*(j-1)+1:nVar*(j), :), 'fro')^2;
            G(nVar*(i-1)+1:nVar*i, :) = G(nVar*(i-1)+1:nVar*i, :) + 2*lambda * ...
                (Sol(nVar*(i-1)+1:nVar*i, :) - Sol(nVar*(j-1)+1:nVar*(j), :)) ;
        end
    end
end
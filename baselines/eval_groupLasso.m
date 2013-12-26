function [err, norm_err  ] =  eval_groupLasso(series, sols,  nLag, index)

nVar  = size(series{1},1);
nType = size(series,1);
T_test = length(index{2});
A_t = [];

for t = index{2}
    x = [];
    for type = 1:nType
        for l = 1:nLag
            x = [x ,series{type}(:,t-l)'];
        end
    end
    A_t = [A_t; x];
end
   

S = cell(1,nType);

for type = 1:nType
    S{type} = sols(:,1+(type-1)*nVar:type*nVar);
end

E = cell(1,nType);
for type = 1:nType
    for n = 1:nVar
        sol = S{type}(:,n);
        pred = A_t*sol;
        true = series{type}(n, index{2})';
        E{type}(n,:) = (true-pred)';
    end
end

err = zeros(nType,1);
norm_err = zeros(nType, 1);
for type =  1:nType
    err(type) = norm(E{type}, 'fro');
    norm_err(type) = err(type) /mean(mean(abs(series{type}(:, index{2}))))/nVar/T_test;
end

end

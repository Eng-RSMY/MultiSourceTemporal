
        function nAttrs = getNAttrs(X)
            for i=1:length(X)
                if ~isempty(X{i})
                    nAttrs=size(X{i},1);
                    return;
                end
            end
        end
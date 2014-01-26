% Test synthetic dataset

[~, nLoc, nTask] = size(A);
nLag = 1;
tTrain = 10;

tValid = 100;
tTest = 100;
nTask = 10;
nLoc = 20;
for i = 1:nTask
    train1.Y{i} = tr_series{i}(:, nLag+1:tTrain);
    train1.X{i} = zeros(nLag*nLoc, (tTrain - nLag));
    for ll = 1:nLag
        train1.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = tr_series{i}(:, nLag+1-ll:tTrain-ll);
    end
    valid1.Y{i} = v_series{i}(:, nLag+1:tValid);
    valid1.X{i} = zeros(nLag*nLoc, (tValid - nLag));
    for ll = 1:nLag
        valid1.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = v_series{i}(:, nLag+1-ll:tValid-ll);
    end
    test1.Y{i} = te_series{i}(:, nLag+1:tTest);
    test1.X{i} = zeros(nLag*nLoc, (tTest - nLag));
    for ll = 1:nLag
        test1.X{i}(nLoc*(ll-1)+1:nLoc*ll, :) = te_series{i}(:, nLag+1-ll:tTest-ll);
    end
end
% greedy construction 

%%

for i = 1:nTask
    for j = 1:nLoc
        % Training
        train2.Y{j+(i-1)*nLoc} = tr_series{i}(j, nLag+1:tTrain)';
        train2.X{j+(i-1)*nLoc} = zeros(nLag*nLoc, (tTrain - nLag));
        for ll = 1:nLag
            train2.X{j+(i-1)*nLoc}(nLoc*(ll-1)+1:nLoc*ll, :) = tr_series{i}(:, nLag+1-ll:tTrain-ll);
        end
        % Validation
        valid2.Y{j+(i-1)*nLoc} = v_series{i}(j, nLag+1:tValid)';
        valid2.X{j+(i-1)*nLoc} = zeros(nLag*nLoc, (tValid - nLag));
        for ll = 1:nLag
            valid2.X{j+(i-1)*nLoc}(nLoc*(ll-1)+1:nLoc*ll, :) = v_series{i}(:, nLag+1-ll:tValid-ll);
        end
        % Testing
        test2.Y{j+(i-1)*nLoc} = te_series{i}(j, nLag+1:tTest)';
        test2.X{j+(i-1)*nLoc} = zeros(nLag*nLoc, (tTest - nLag));
        for ll = 1:nLag
            test2.X{j+(i-1)*nLoc}(nLoc*(ll-1)+1:nLoc*ll, :) = te_series{i}(:, nLag+1-ll:tTest-ll);
        end
    end
end

% MLMTL construction 


%%
for i = 1:10
    
    Y1 = train1.Y{i};
    Y2 = train2.Y{i};

    if(train1.Y{i}~=train2.Y{i})
        fprintf('Y not equal\n');
    end

    X1 = train1.X{i};
    X2 = train2.X{i};

    if (train1.X{i}~=train2.X{i})
        fprintf('X not equal\n');
    end

end

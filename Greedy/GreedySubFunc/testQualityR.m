function rmse =  testQualityR(estMat, index, trueMat)
%TESTQUALITYK Summary of this function goes here
%   Detailed explanation goes here
rmse = 0;
nnZ = 0;
for i = 1:length(trueMat)
    nnZ = nnZ + sum(sum(trueMat{i}(index, :) >0));
    rmse = rmse + norm( (squeeze(estMat(:, index, i))' - ...
        trueMat{i}(index, :)).*(trueMat{i}(index, :) >0), 'fro')^2;
end
rmse = sqrt(rmse/nnZ);

end


function rmse =  testQualityK(estMat, index, trueMat)
%TESTQUALITYK Summary of this function goes here
%   Detailed explanation goes here
rmse = 0;
for i = 1:length(trueMat)
    rmse = rmse + norm(squeeze(estMat(:, index, i))' - trueMat{i}(index, :), 'fro')^2;
end
rmse = sqrt(rmse/length(trueMat)/size(trueMat{1}, 2)/length(index));

end


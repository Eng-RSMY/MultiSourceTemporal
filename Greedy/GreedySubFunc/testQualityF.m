function rmse = testQualityF(Sol, U, X, Y)
rmse = 0;
for i = 1:length(X)
    mat = U\squeeze(Sol(:, :, i));
    rmse = rmse + norm(mat*X{i} - Y{i}, 'fro')^2;
end
rmse = sqrt(rmse/length(X)/numel(Y{1}));
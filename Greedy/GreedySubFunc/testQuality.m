function quality = testQuality(Sol, A, X, Y)

quality = [0;0;0];
temp = 0;
temp2 = 0;
for i = 1:size(Sol, 3)
    quality(1) = quality(1) + norm(A - squeeze(Sol(:, :, i)), 'fro')^2;
    temp = temp + norm(A*X{i} - squeeze(Sol(:, :, i))*X{i}, 'fro');
    temp2 = temp2 + norm(Y{i}-A*X{i}, 'fro');
end
quality(1) = sqrt(quality(1)/size(Sol, 3))/norm(A, 'fro');

quality(2) = quality(2) + rank(unfld(Sol, 1));
quality(2) = quality(2) + rank(unfld(Sol, 2));
quality(2) = quality(2) + rank(unfld(Sol, 3));

% quality(3) = TRComplexity(Sol);

end
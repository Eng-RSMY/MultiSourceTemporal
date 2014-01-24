function quality = testQuality(Sol, A, X, Y)

quality = [0;0;0;0;0];
% temp = 0;
% temp2 = 0;
for i = 1:size(Sol, 3)
    quality(1) = quality(1) + norm(squeeze(A(:, :, i)) - squeeze(Sol(:, :, i)), 'fro')^2;%/norm(squeeze(A(:,:,i)), 'fro')^2;
%     temp = temp + norm(A*X{i} - squeeze(Sol(:, :, i))*X{i}, 'fro');
%     temp2 = temp2 + norm(Y{i}-A*X{i}, 'fro');
end
quality(1) = sqrt(quality(1)/size(Sol, 3));

quality(2) = quality(2) + rank(unfld(Sol, 1));
quality(2) = quality(2) + rank(unfld(Sol, 2));
quality(2) = quality(2) + rank(unfld(Sol, 3));

% quality(3) = TRComplexity(Sol);

for ll = 1:size(Sol, 3)
    quality(4) = quality(4) + norm(Y{ll} - squeeze(Sol(:, :, ll))*X{ll}, 'fro')^2;
    quality(5) = quality(5)/mean(Y{ll}(:).^2);
end
quality(4) = quality(4)/size(Y{1}, 2);
quality(4:5) = sqrt(quality(4:5)/size(Sol, 3)/size(X{1}, 2));

end
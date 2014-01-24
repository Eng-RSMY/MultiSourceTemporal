function [q1, q2, q3, q4] = testQuality2(Sol, A, Y, X)
% [errReg, rankReg, trcompReg, predReg]
q1 = 0;
for i = 1:size(Sol, 2)
    q1 = q1 + norm(squeeze(A(:,:,i)) - squeeze(Sol(:, i, :)), 'fro')^2/norm(squeeze(A(:,:,i)), 'fro')^2;
end
q1 = sqrt(q1/size(Sol, 2));

q2 = rank(unfld(Sol, 1));
q2 = q2 + rank(unfld(Sol, 2));
q2 = q2 + rank(unfld(Sol, 3));

q3 = 0;
% q3= TRComplexity(Sol);
q4 = 0;
[~, t, n] = size(Sol);
for i = 1:t
    for j = 1:n
        q4 = q4 + norm(Y{(i-1)*n+j}' - squeeze(Sol(:, i, j))'*X{(i-1)*n+j})^2;
    end
end
q4 = q4/length(Y)/length(Y{1});

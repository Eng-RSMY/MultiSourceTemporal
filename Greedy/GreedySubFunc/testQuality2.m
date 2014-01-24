function [q1, q2, q3] = testQuality2(Sol, A)

q1 = 0;
for i = 1:size(Sol, 2)
    q1 = q1 + norm(A - squeeze(Sol(:, i, :)), 'fro')^2;
end
q1 = sqrt(q1/size(Sol, 2))/norm(A, 'fro');

q2 = rank(unfld(Sol, 1));
q2 = q2 + rank(unfld(Sol, 2));
q2 = q2 + rank(unfld(Sol, 3));

q3 = 0;
% q3= TRComplexity(Sol);

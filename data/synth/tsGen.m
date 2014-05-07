% Low-rank time series generation
function [series W] = tsGen(A,T)
nTasks = size(A,3);
p = size(A,2);
series = cell(nTasks,1);

epsilon = 0.5;
for j = 1:nTasks
    A_t = squeeze(A(:,:,j));
    tSeries = zeros(p, T);
    tSeries(:, 1) = randn(p, 1);
    for t = 2:T
        tSeries(:, t) = A_t*tSeries(:, t-1) + epsilon*randn(p, 1);
    end
%     subplot(1,nTasks,j);
%     plot(mean(abs(tSeries), 1));
    
    series{j} = tSeries;   
end
end



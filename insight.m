% Getting insight
clc
clear

% load climateP17
load tensor_checkin_counts
[nLoc, tLen] = size(series{1});
nTask = length(series);

tensor = zeros(nLoc, tLen, nTask);
for t = 1:nTask
    tensor(:, :, t) = series{t};
end

for i = 1:3
    matrix = unfld(tensor, i);
    subplot(1, 3, i)
    s = svd(matrix);
%     ss = cumsum(s);
    stairs(s)
end


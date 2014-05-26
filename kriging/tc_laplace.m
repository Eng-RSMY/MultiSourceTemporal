function pred = tc_laplace( data, index, locations )
% data: an nTask x 1 cell
% Each cell is an nLoc x tLen matrix
nTask = length(data);
[nLoc, tLen] = size(data{1});

sigma = 0.5;
sim = similarity(locations, sigma);

% Initialize
Sol = cell(nTask, 1);
for t=1:nTask
    Sol{t} = zeros(nLoc, tLen);
end



end

function sim = similarity(locations, sigma)
nLoc = size(locations, 1);
sim = exp(-( (locations(:, 1)*ones(1, nLoc) - ones(nLoc, 1)*locations(:, 1)').^2 + ...
    (locations(:, 2)*ones(1, nLoc) - ones(nLoc, 1)*locations(:, 2)').^2 )/sigma);

end
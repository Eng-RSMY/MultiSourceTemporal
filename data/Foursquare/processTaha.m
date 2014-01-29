% The goal is to properly preprocess the 4Sq dataset
clear
clc

load tensor_checkin_counts.mat
[nLoc, tLen] = size(series{1}); 
tLen = 3600;  % To make thing rounded
nLoc = 50;
Factor  = 3;
% Every 9 hours
for i = 1:length(series)
    data = zeros(nLoc, tLen/Factor);
    for j = 1:Factor
        data = data + series{i}(1:nLoc, j:Factor:tLen);
    end
    
%     %% Remove the daily pattern
    lenNew = tLen/Factor;
%     aggMean = mean(data, 1);
%     spectrogram(aggMean)  
%     data = data - mean(aggMean);
%     figure; spectrogram(mean(data, 1))  
%     
%     dFac = (24/Factor);
%     index = 1:floor(lenNew/dFac)*dFac;
%     aggMean = mean(data, 1);
%     aggMeanWeek = mean(reshape(aggMean(index), dFac, floor(lenNew/dFac)), 2)';
%     trend = repmat( ones(nLoc, 1)*aggMeanWeek, 1, floor(lenNew/dFac)+1);
%     data = data - trend(:, 1:lenNew);
%     figure; spectrogram(mean(data, 1))  
%     %% Normalize
    data  = data - mean(data, 2)*ones(1, lenNew);
%     data = data ./ (std(data, 0, 2)*ones(1, lenNew));
    series{i} = data;
    
    close all
end

save('norm_4sq_small.mat', 'series')
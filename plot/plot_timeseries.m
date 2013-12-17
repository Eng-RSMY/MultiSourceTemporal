load 'wind.mat';
wind = timeseries(obs(:,[1:2,150]),'name','wind');
wind.TimeInfo.Units = 'days';
load 'temp.mat';
temp = timeseries(obs(:,[1:2,150]),'name','temp');
temp.TimeInfo.Units = 'days';
load 'rain.mat';
rain = timeseries(obs(:,[1:2,150]),'name','rain');
rain.TimeInfo.Units = 'days';
%%
subplot(1,3,1);
plot((wind)); 
title ('wind');
subplot(1,3,2);
plot((temp));
title ('temp');
subplot(1,3,3);
plot((rain));
title ('rain');

legend('S1','S2','S150');
set(findall(gcf,'type','text'),'fontSize',14,'fontWeight','bold')


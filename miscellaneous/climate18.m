
% filename = '/Users/roseyu/Downloads/DataSet/Climate/climate18.csv';
% data = csvread(filename);

%%

addpath(genpath('./'));
load climate18.mat;

years = [1990:2002];
year_num =13;
months = [1:12];
month_num = 12;
loc_num = 125;

nA = 18;
nL = loc_num;
nT = year_num * month_num;
[N,C] = size(climate18);

climate18_3Dmat = zeros(nT, nA, nL);
for loc = 1:loc_num
    start_row = (loc-1)*nT+1;
    end_row = loc*nT;
    climate18_3Dmat(:,:,loc) = climate18(start_row:end_row, 5:22);
end

climate18_permute =  permute(climate18_3Dmat,[3,1,2]);
%%
climate18_cell = cell(1,nA);

for agent = 1:nA
    climate18_cell{agent} = climate18_permute(:,:,agent);
end

%%


    




            
    
    
    






users = unique(gowalla_daily_checkin(:,1));
num_users = length(users);
series = cell(num_users,1);
num_locations = 725;
num_times = 627;

for u = 1:num_users
    series{u} = zeros(num_locations, num_times);
end

for i = 1:length(gowalla_daily_checkin)
    disp(i);
    record = gowalla_daily_checkin(i,:);
    user = find(users==record(1));
    time = record(2)+1;
    loc = record(3)*29+record(4);
    series{user}(loc,time) = series{user}(loc,time) +1;
end

%%
series_sparse = cell(num_users,1);

for u = 1:num_users
    series_sparse{u} = sparse(series{u});
end
    
%% normalize
series_norm = cell(num_users,1);
Factor  = 3;
[nLoc, tLen] = size(series_sparse{1}); 

for i = 1:length(series)
    data = zeros(nLoc, tLen/Factor);
    for j = 1:Factor
        data = data + series_sparse{i}(1:nLoc, j:Factor:tLen);
    end
    lenNew = tLen/Factor;
    data  = data - mean(data, 2)*ones(1, lenNew);
    series_norm{i} = data;
end

save('./data/Gowalla/norm_Gowalla.mat','series_sparse');
%% small set

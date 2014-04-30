users = unique(gowalla_daily_checkin(:,1));
num_users = length(users);
series = cell(num_users,1);
num_locations = 725;
num_times = 627;

for u = 1:num_users
    series{u} = zeros(num_locations, num_times);
end

for i = 1:length(gowalla_daily_checkin)
    record = gowalla_daily_checkin(i,:);
    user = find(users==record(1));
    time = record(2)+1;
    loc = record(3)*29+record(4);
    series{user}(loc,time) = series{user}(loc,time) +1;
end
    
    
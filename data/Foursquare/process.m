%%
[N, T] = size(checkin_counts_hourly);
window = 6;
wT = ceil(T/window);

stands_p = 1:window:(wT+1)*window;
checkin_counts_window = zeros(N,wT);
for t= 1:wT
    start_p= stands_p(t);
    ends_p = stands_p(t+1)-1;
    if (t==wT)
        start_p = stands_p(t);
        ends_p = T;
    end
    tmp = checkin_counts_hourly(:,start_p:ends_p);
    checkin_counts_window(:,t) = sum(tmp,2);
end

%%
subplot(1,2,1);
scatter(venue_loc(:,1),venue_loc(:,2))
subplot(1,2,2);
scatter(checkin_loc(:,1),checkin_loc(:,2))
%%
% cum_sum_val  = cumsum(venue_checkin_counts,2);
% plot(cum_sum_val(3,:))

% day_sum = sum(venue_checkin_counts,1);
% plot(1:T, day_sum);

spectrogram(day_sum-mean(day_sum), 128);

%%
% choose 200 active users
thres = 200;
checkin_sum = sum(active_checkin_counts,2);
[~,order ] = sort(checkin_sum,'descend');

top_users = active_user_IDs (order(1:thres));

dlmwrite('/Users/roseyu/Downloads/DataSet/Foursquare/top_users.txt',top_users);
%%
N = length(Top_Common_User);
bigN = length(active_checkin_counts);
idx = zeros(N,1)
for  n = 1:N
    idx(n,1) = find(active_user_IDs==Top_Common_User(n));
end

select_idx = zeros(bigN,1); 

for n = 1:N
    select_idx(idx(n)) = 1;
end
    
select_idx  = logical (select_idx);  
top_checkin = active_checkin_counts(select_idx,:);
top_sum = sum(sum(top_checkin,2));

%%
nC = 15;
nU = 121;
tensor_checkin_counts = cell(nC,1);
for c = 1:nC
    start_idx = (c-1)*nU+1;
    end_idx = c*nU;
    
    tensor_checkin_counts{c} = checkin_counts(start_idx:end_idx,:);
end

%%
% for c = 1:nC
%     sum_check(c) = sum(sum(tensor_checkin_counts{c}));
% end

tmp = sum(tensor_checkin_counts{1});
%%

% create a small dataset

nType = length(series);
series_s = cell(nType,1);

for t = 1:nType
    tmp = series{t};
    series_s{t} = tmp(1:60,1:300);
end
%% create adjacent matrix with the top friendship
pair = Top_Friendship;
users = Top_Common_User;
nPair = length(pair);
F = zeros(121, 121);
for i = 1:nPair
    U1 = pair(i,1);
    U2 = pair(i,2);
    U1_idx = find(users==U1);
    disp(U1_idx)
    U2_idx = find(users==U2);
    disp(U2_idx)
    F(U1_idx,U2_idx) = F(U1_idx,U2_idx) +1;
    F(U2_idx,U1_idx) = F(U2_idx,U1_idx) +1;
end



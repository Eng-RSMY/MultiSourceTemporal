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


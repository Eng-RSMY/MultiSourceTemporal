%%
% compute the covariance for the partial index
% 1. simple kriging --- 4.25? exponential covairance ( depends only on
% distance )
sigma_0 = 0; sigma_1=0.01; theta_1 = 1; theta_2=1;
cov_val = exp_cov(names(:,2:3), sigma_0, sigma_1, theta_1, theta_2);


cov_observe = cov_val(observe_idx,observe_idx);

kriging_est = cell(nTasks,1);
for t = 1:nTasks
    kriging_est{t} = zeros(nMissing,nTasks);
end
for t  = 1:nTasks
    for  time = 1:nTime
        kriging_est{t}(:,time)  = cov_val(missing_idx,observe_idx)*inv(cov_observe) * series_partial{t}(:,time);
        
    end
end
%%
% evaluate performance
err_RMSE = zeros(nTasks,1);
for t = 1:nTasks
    err_RMSE(t) = sqrt(norm(kriging_est{t} - series{t}(missing_idx,:),'fro')^2/(nTime*nMissing));
end

%% 
% visualization
% subplot(3,1,1);
% A = randi([10,60],100,100);
% colormap('hot')
% imagesc(A)






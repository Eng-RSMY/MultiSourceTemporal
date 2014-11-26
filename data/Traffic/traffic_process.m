%process the traffic data
%to prepare input for the low-rank algorithm

%% dense highway
num_location = 115;
num_timestamp = 180;
num_day = 23;
speed_series =  DenseAprilhighway(:,4);
series = reshape(speed_series,[num_timestamp, num_location, num_day] );
series = permute(series, [2,1,3]);
latlng = DenseSensors(:,3:4);

%% sparse highway
num_location = 100;
num_timestamp = 180;
num_day = 23;
speed_series =  SparseAprilhighway(:,4);
series = reshape(speed_series,[num_timestamp, num_location, num_day] );
series = permute(series, [2,1,3]);
latlng = SparseSensors(:,3:4);

%% missing index
num_fold = 10;
num_loc = 115;
idx_missing = zeros(num_loc, num_fold);
for i = 1: num_fold
    idx = rand(num_loc,1);
    idx_missing(:,i)= (idx < 0.05);
end
%% calculate non-zero RMSD
load 'dense_highway_april.mat'
load 'idx_missing_dense.mat'
load 'tcLap_dense_highway.mat'

num_fold = 10;

RMSE_tcLap = zeros(1,num_fold);

for i = 1:num_fold
    idx = logical(idx_missing(:,i));  
    X_test = X( idx,:,:);
    non_zero_idx = (X_test ~=0);
    X_test_nonzero = X_test(non_zero_idx);
    X_est = tcLap_est{i};
    X_est_nonzero = X_est(non_zero_idx);
    RMSE_tcLap(i)  = sqrt(norm_fro(X_est_nonzero-X_test_nonzero)^2/ numel(X_test_nonzero));
end
disp(mean(RMSE_tcLap(i)));

fprintf('finish evaluation\n');


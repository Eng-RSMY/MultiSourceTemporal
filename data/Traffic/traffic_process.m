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
idx_missing = rand(100,1);
idx_missing = (idx_missing > 0.05);
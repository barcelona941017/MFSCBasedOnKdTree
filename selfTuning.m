function A_LS = selfTuning(data)
temp_data = data;
temp_data = temp_data - repmat(mean(temp_data),size(temp_data,1),1);
temp = max(max(abs(temp_data)));
temp_data = temp_data / temp;
% tic;

D = dist2(temp_data,temp_data);              %% Euclidean distance
neighbor_num = 10;
scale = 0.04;
A = exp(-D/(scale^2));       %% Standard affinity matrix (single scale)
[D_LS,A_LS,LS] = scale_dist(D,floor(neighbor_num/2)); %% Locally scaled affinity matrix
clear D_LS; clear LS;
ZERO_DIAG = ~eye(size(temp_data,1));
A = A.*ZERO_DIAG;
A_LS = A_LS.*ZERO_DIAG;   
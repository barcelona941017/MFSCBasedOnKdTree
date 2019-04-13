function SegLabel = ProcessDatasetByMFSC(data, threshold, start_level, nbCluster, n)

[kdTree_stru, total_leaf_node]=total_cluster_struct(data, threshold, start_level);
nb_total_leaf_node = length(total_leaf_node);
total_leaf_node_index = [];
for i = 1:nb_total_leaf_node
    leaf_node_index = total_leaf_node(i).index(1);
    total_leaf_node_index = [total_leaf_node_index leaf_node_index];
end
leaf_data = data(total_leaf_node_index,:);                                   %代表点们
% show_leaf_data = leaf_data';%代表点的显示
% plot(show_leaf_data(1,:),show_leaf_data(2,:),'ks', 'MarkerFaceColor','k','MarkerSize',5); axis image; hold on; 
[total_trans_Matrix, Q_IndexTable] = getTransMatrix(kdTree_stru, total_leaf_node, n, start_level);

W = selfTuning(leaf_data);
%[W,Dist] = compute_relation(leaf_data');                                    %代表点的W 输入需要列表示个数， 行表示特征
dataNcut.valeurMin=1e-6;
W = sparsifyc(W,dataNcut.valeurMin);

[IndiMat, order_of_node] = reprePointIndictorMatrix(data, W, Q_IndexTable, kdTree_stru, total_leaf_node_index,start_level, nbCluster);   %指示向量
IndiMat_sparse = sparse(IndiMat);

total_trans_Matrix = total_trans_Matrix(order_of_node,:);
W = W(order_of_node,order_of_node);
d = sum(abs(W),2);
n = size(W,1);
W = spdiags(d,0,n,n) - W;
D = 1./sqrt(d+eps);

PNew = spmtimesd(W,D,D);
PNew = IndiMat_sparse * PNew * IndiMat_sparse';
[eigenVector, s] = eigs(PNew, nbCluster,'sm');
s = real(diag(s));
[x,y] = sort(-s); 
Eigenvalues = -x;
eigenVector= IndiMat_sparse' * real(eigenVector);                          %先转回代表点空间
eigenVector = total_trans_Matrix' * eigenVector;                           %再转回原空间

[row,col] = size(eigenVector);
eigenVector2 = eigenVector.*eigenVector;
totalQ = sum(eigenVector2,2);
for i =1:row  
    eigenVector(i,:) = eigenVector(i,:)/sqrt(totalQ(i));
end

[centers,U] = fcm(eigenVector,nbCluster );
SegLabel = zeros(1,n);
maxU = max(U);
for ii = 1 :nbCluster
   SegLabel(U(ii,:)== maxU) = ii;
end
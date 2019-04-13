function SegLabel = ProcessDatasetByFSC(data, threshold, nbCluster, n)

data_num=length(data);
current_node.data=data;
current_node.index=1:data_num;
current_node.parent=[];
current_node.left=[];
current_node.right=[];
total_leaf_node = [];
nb_total_leaf_node = 0;
re_caculate_time = 0;
while 1
    total_leaf_node1 = getAllLeafNode(current_node, threshold, total_leaf_node);
    nb_total_leaf_node = length(total_leaf_node1);
    nb_total_leaf_node
    if(nb_total_leaf_node > 0 && nb_total_leaf_node < 10000)
        break;
    else
        re_caculate_time = re_caculate_time + 1;
        threshold = threshold + 2;
    end
end
total_leaf_node = total_leaf_node1;
re_caculate_time
total_leaf_node_index = [];
for i = 1:nb_total_leaf_node                                               %对取出的叶子节点进行采样，这里的采样并不是按百分比进行采样，而是直接采一个点
    leaf_node_index = total_leaf_node(i).index(1);
    total_leaf_node_index = [total_leaf_node_index leaf_node_index];
end
leaf_data = data(total_leaf_node_index,:);                                   %代表点们

nb_total_leaf_node = length(total_leaf_node);                          %所有叶子节点的个数;n:所有节点的个数
total_trans_Matrix = sparse(nb_total_leaf_node, n);                     %根据total_leaf_node中叶子节点的顺序得到的最终的转换矩阵Q
for i = 1:nb_total_leaf_node;
    leaf_node_index = total_leaf_node(i).index;
    total_trans_Matrix(i, leaf_node_index) = 1;                        %将相应位置赋1
end

W = selfTuning(leaf_data);
%[W,Dist] = compute_relation(leaf_data');                                    %代表点的W 输入需要列表示个数， 行表示特征
dataNcut.valeurMin=1e-6;
W = sparsifyc(W,dataNcut.valeurMin);

%[IndiMat, order_of_node] = reprePointIndictorMatrix(data, W, Q_IndexTable, kdTree_stru, total_leaf_node_index,start_level, nbCluster);   %指示向量
%IndiMat_sparse = sparse(IndiMat);

%total_trans_Matrix = total_trans_Matrix(order_of_node,:);
%W = W(order_of_node,order_of_node);
d = sum(abs(W),2);
n = size(W,1);
W = spdiags(d,0,n,n) - W;
D = 1./sqrt(d+eps);

PNew = spmtimesd(W,D,D);
[eigenVector, s] = eigs(PNew, nbCluster,'sm');
s = real(diag(s));
[x,y] = sort(-s); 
Eigenvalues = -x;
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
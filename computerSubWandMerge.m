function kdTree_stru = computerSubWandMerge(W, W_index, W_index_saveStruct, node, i, kdTree_stru, nbCluster)
sub_W = W(W_index, W_index);
[wr, wc] = size(sub_W);
offset = 5e-1;
d = sum(abs(sub_W), 2);
d = d + offset * 2;
eps = 1e-6;
Dinvsqrt = 1./sqrt(d + eps);
sub_W = spdiags(d, 0, wr, wc) - sub_W;
LapMatrix = spmtimesd(sub_W, Dinvsqrt, Dinvsqrt);
Li = node.comp_Q * LapMatrix * node.comp_Q';
[eigenVector, eigenValue] = eigs(Li, nbCluster, 'sm');
eigenVector = node.comp_Q' * eigenVector;%这里特征向量是按列存储的。即列大于行
[eig_r,eig_c] = size(eigenVector');
if  isequal(node.parent.left.index, node.index)                    %如果当前节点是父亲节点的左孩子 
    bro_childNode_posi = node.parent.right;                                 %兄弟节点的位置
    bro_childNode = kdTree_stru{bro_childNode_posi.depth, bro_childNode_posi.index(1)};%在kdTree_stru中找到那个节点
    if ~isempty(bro_childNode.leaf_node_index)
         nb_parent_childNode = length(bro_childNode.leaf_node_index) + length(node.leaf_node_index);
    else
        nb_parent_childNode = length(W_index_saveStruct{bro_childNode.depth, bro_childNode.index(1)}) + length(W_index_saveStruct{node.depth, node.index(1)});%父亲节点的叶子节点数。
    end
    q_parent = zeros(eig_r, nb_parent_childNode);
    q_parent(:, 1: eig_c) = eigenVector';
    kdTree_stru{node.depth,i}.trans_Q = [kdTree_stru{node.depth, i}.trans_Q;q_parent];   %把树结构的相应位置进行更新
    kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q = [kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q; q_parent];
else if isequal(node.parent.right.index, node.index)                %如果当前节点是父亲节点的右孩子
    bro_childNode_posi = node.parent.left;                                 %兄弟节点的位置
    bro_childNode = kdTree_stru{bro_childNode_posi.depth, bro_childNode_posi.index(1)};%在kdTree_stru中找到那个节点
    if ~isempty(bro_childNode.leaf_node_index)
         nb_parent_childNode = length(bro_childNode.leaf_node_index) + length(node.leaf_node_index);
    else
        nb_parent_childNode = length(W_index_saveStruct{bro_childNode.depth, bro_childNode.index(1)}) + length(W_index_saveStruct{node.depth, node.index(1)});%父亲节点的叶子节点数。
    end
    q_parent = zeros(eig_r, nb_parent_childNode);
    q_parent(:, (end - eig_c + 1):end) = eigenVector';
    kdTree_stru{node.depth, i}.trans_Q = [kdTree_stru{node.depth, i}.trans_Q; q_parent];   %把树结构的相应位置进行更新
    kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q = [kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q; q_parent];
    end
end

end
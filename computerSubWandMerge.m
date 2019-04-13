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
eigenVector = node.comp_Q' * eigenVector;%�������������ǰ��д洢�ġ����д�����
[eig_r,eig_c] = size(eigenVector');
if  isequal(node.parent.left.index, node.index)                    %�����ǰ�ڵ��Ǹ��׽ڵ������ 
    bro_childNode_posi = node.parent.right;                                 %�ֵܽڵ��λ��
    bro_childNode = kdTree_stru{bro_childNode_posi.depth, bro_childNode_posi.index(1)};%��kdTree_stru���ҵ��Ǹ��ڵ�
    if ~isempty(bro_childNode.leaf_node_index)
         nb_parent_childNode = length(bro_childNode.leaf_node_index) + length(node.leaf_node_index);
    else
        nb_parent_childNode = length(W_index_saveStruct{bro_childNode.depth, bro_childNode.index(1)}) + length(W_index_saveStruct{node.depth, node.index(1)});%���׽ڵ��Ҷ�ӽڵ�����
    end
    q_parent = zeros(eig_r, nb_parent_childNode);
    q_parent(:, 1: eig_c) = eigenVector';
    kdTree_stru{node.depth,i}.trans_Q = [kdTree_stru{node.depth, i}.trans_Q;q_parent];   %�����ṹ����Ӧλ�ý��и���
    kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q = [kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q; q_parent];
else if isequal(node.parent.right.index, node.index)                %�����ǰ�ڵ��Ǹ��׽ڵ���Һ���
    bro_childNode_posi = node.parent.left;                                 %�ֵܽڵ��λ��
    bro_childNode = kdTree_stru{bro_childNode_posi.depth, bro_childNode_posi.index(1)};%��kdTree_stru���ҵ��Ǹ��ڵ�
    if ~isempty(bro_childNode.leaf_node_index)
         nb_parent_childNode = length(bro_childNode.leaf_node_index) + length(node.leaf_node_index);
    else
        nb_parent_childNode = length(W_index_saveStruct{bro_childNode.depth, bro_childNode.index(1)}) + length(W_index_saveStruct{node.depth, node.index(1)});%���׽ڵ��Ҷ�ӽڵ�����
    end
    q_parent = zeros(eig_r, nb_parent_childNode);
    q_parent(:, (end - eig_c + 1):end) = eigenVector';
    kdTree_stru{node.depth, i}.trans_Q = [kdTree_stru{node.depth, i}.trans_Q; q_parent];   %�����ṹ����Ӧλ�ý��и���
    kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q = [kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q; q_parent];
    end
end

end
function [W_index_saveStruct, kdTree_stru] = processLeafNode(node, i, kdTree_stru, W_index_saveStruct, Q_IndexTable)
if isequal(node.parent.right.index, node.index)                                           %�����ǰ�ڵ��Ǹ��׽ڵ���Һ��ӵĻ�
    bro_childNode_posi = node.parent.left;                                 %�ֵܽڵ��λ��
    bro_childNode = kdTree_stru{bro_childNode_posi.depth, bro_childNode_posi.index(1)};%��kdTree_stru���ҵ��Ǹ��ڵ�
    nb_bro_childNode = length(bro_childNode.leaf_node_index);
    if nb_bro_childNode == 0                                               %����ֵܽڵ���Ҷ�ӽڵ�
        nb_bro_childNode = 1;
    end
    nb_parent_childNode = nb_bro_childNode + 1;
    kdTree_stru{node.depth,i}.comp_Q = 1;
    q_parent = zeros(1,nb_parent_childNode + 1);
    q_parent(nb_parent_childNode) = 1;
else if isequal(node.parent.left.index, node.index)                                       %�����ǰ�ڵ��Ǹ��׽ڵ�����ӵĻ�
        bro_childNode_posi = node.parent.right;                                 %�ֵܽڵ��λ��
        bro_childNode = kdTree_stru{bro_childNode_posi.depth, bro_childNode_posi.index(1)};%��kdTree_stru���ҵ��Ǹ��ڵ�
        nb_bro_childNode = length(bro_childNode.leaf_node_index);
        if nb_bro_childNode == 0
            nb_bro_childNode = 1;
        end
        nb_parent_childNode = nb_bro_childNode + 1; %�Լ����ֵܽڵ�ĺ��ӽڵ���
        kdTree_stru{node.depth,i}.comp_Q = 1;
        q_parent = zeros(1,nb_parent_childNode + 1);
        q_parent(1) = 1;
    end
end
    %W_index_saveStruct{level, node.index(1)} = Q_IndexTable(1, min(node.index));
    W_index_saveStruct{node.parent.depth, min(node.parent.index)} = [W_index_saveStruct{node.parent.depth, min(node.parent.index)}; Q_IndexTable(1, min(node.index))]; 
    kdTree_stru{node.depth,i}.trans_Q = [kdTree_stru{node.depth,i}.trans_Q;q_parent];   %�����ṹ����Ӧλ�ý��и���
    kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q = [kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q;q_parent];         
end
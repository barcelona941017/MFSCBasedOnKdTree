function [W_index_saveStruct, kdTree_stru] = processLeafNode(node, i, kdTree_stru, W_index_saveStruct, Q_IndexTable)
if isequal(node.parent.right.index, node.index)                                           %如果当前节点是父亲节点的右孩子的话
    bro_childNode_posi = node.parent.left;                                 %兄弟节点的位置
    bro_childNode = kdTree_stru{bro_childNode_posi.depth, bro_childNode_posi.index(1)};%在kdTree_stru中找到那个节点
    nb_bro_childNode = length(bro_childNode.leaf_node_index);
    if nb_bro_childNode == 0                                               %如果兄弟节点是叶子节点
        nb_bro_childNode = 1;
    end
    nb_parent_childNode = nb_bro_childNode + 1;
    kdTree_stru{node.depth,i}.comp_Q = 1;
    q_parent = zeros(1,nb_parent_childNode + 1);
    q_parent(nb_parent_childNode) = 1;
else if isequal(node.parent.left.index, node.index)                                       %如果当前节点是父亲节点的左孩子的话
        bro_childNode_posi = node.parent.right;                                 %兄弟节点的位置
        bro_childNode = kdTree_stru{bro_childNode_posi.depth, bro_childNode_posi.index(1)};%在kdTree_stru中找到那个节点
        nb_bro_childNode = length(bro_childNode.leaf_node_index);
        if nb_bro_childNode == 0
            nb_bro_childNode = 1;
        end
        nb_parent_childNode = nb_bro_childNode + 1; %自己的兄弟节点的孩子节点数
        kdTree_stru{node.depth,i}.comp_Q = 1;
        q_parent = zeros(1,nb_parent_childNode + 1);
        q_parent(1) = 1;
    end
end
    %W_index_saveStruct{level, node.index(1)} = Q_IndexTable(1, min(node.index));
    W_index_saveStruct{node.parent.depth, min(node.parent.index)} = [W_index_saveStruct{node.parent.depth, min(node.parent.index)}; Q_IndexTable(1, min(node.index))]; 
    kdTree_stru{node.depth,i}.trans_Q = [kdTree_stru{node.depth,i}.trans_Q;q_parent];   %把树结构的相应位置进行更新
    kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q = [kdTree_stru{node.parent.depth, node.parent.index(1)}.comp_Q;q_parent];         
end
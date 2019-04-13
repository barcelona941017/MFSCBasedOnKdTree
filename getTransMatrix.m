function [total_trans_Matrix, Q_IndexTable] = getTransMatrix(kdTree_stru, total_leaf_node, n, start_level)   
    nb_total_leaf_node = length(total_leaf_node);                          %所有叶子节点的个数;n:所有节点的个数
    Q_IndexTable = cell(1, n);                                             %Q_IndexTable：start_level上每一个节点的叶子节点的index
    total_trans_Matrix = zeros(nb_total_leaf_node, n);                     %根据total_leaf_node中叶子节点的顺序得到的最终的转换矩阵Q
    for i = 1:nb_total_leaf_node;
        leaf_node_index = total_leaf_node(i).index;
        total_trans_Matrix(i, leaf_node_index) = 1;                        %将相应位置赋1
    end
    level_content = kdTree_stru(start_level,:);            %kdTree_stru在start_level层保存了节点的叶子节点的信息
    level_node = cellfun('isempty', level_content);
    node_have_leafInfo = find(level_node == 0); %当前层所有的节点
    for node_index = node_have_leafInfo
        node = level_content{1, node_index};
        Q_IndexTable{1, min(node.index)} = node.leaf_node_index; 
    end
end
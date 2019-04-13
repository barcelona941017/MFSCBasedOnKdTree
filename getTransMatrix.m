function [total_trans_Matrix, Q_IndexTable] = getTransMatrix(kdTree_stru, total_leaf_node, n, start_level)   
    nb_total_leaf_node = length(total_leaf_node);                          %����Ҷ�ӽڵ�ĸ���;n:���нڵ�ĸ���
    Q_IndexTable = cell(1, n);                                             %Q_IndexTable��start_level��ÿһ���ڵ��Ҷ�ӽڵ��index
    total_trans_Matrix = zeros(nb_total_leaf_node, n);                     %����total_leaf_node��Ҷ�ӽڵ��˳��õ������յ�ת������Q
    for i = 1:nb_total_leaf_node;
        leaf_node_index = total_leaf_node(i).index;
        total_trans_Matrix(i, leaf_node_index) = 1;                        %����Ӧλ�ø�1
    end
    level_content = kdTree_stru(start_level,:);            %kdTree_stru��start_level�㱣���˽ڵ��Ҷ�ӽڵ����Ϣ
    level_node = cellfun('isempty', level_content);
    node_have_leafInfo = find(level_node == 0); %��ǰ�����еĽڵ�
    for node_index = node_have_leafInfo
        node = level_content{1, node_index};
        Q_IndexTable{1, min(node.index)} = node.leaf_node_index; 
    end
end
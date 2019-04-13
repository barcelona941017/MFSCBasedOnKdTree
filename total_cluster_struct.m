function [node_cell, leaf_node_matrix]=total_cluster_struct(data,thres,depth)

[node_cell,leaf_node_matrix] = cluster_cell_loop(thres, data);
level_node = cellfun('isempty', node_cell);
index = find(level_node == 0); %当前层所有的节点
for i = index'
    node_cell{i}.leaf_node_index = [];
    for j = 1:length(leaf_node_matrix)
        if(node_cell{i}.depth == depth && all(ismember(leaf_node_matrix(j).index, node_cell{i}.index)))
            temp.index = leaf_node_matrix(j).index;
            node_cell{i}.leaf_node_index = [node_cell{i}.leaf_node_index;temp];
        end
    end
end

for i = index'
    if isstruct(node_cell{i}.left) && isstruct(node_cell{i}.right)
        node_leftChild = node_cell{i}.left;
        node_rightChild = node_cell{i}.right;
        node_cell{i}.left = node_cell{node_leftChild.depth, node_leftChild.index(1)};
        node_cell{i}.right = node_cell{node_rightChild.depth, node_rightChild.index(1)};
    end   
end








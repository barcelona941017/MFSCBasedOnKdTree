function [node_cell,leaf_node_matrix] = cluster_cell_loop(threshold, data)
leaf_node_matrix = [];
n = length(data);
max_rows = 2 * floor(log2(n));
node_cell = cell(max_rows + 1, n);
node.data = data;
node.index = 1:n;
node.length = n;
node.left = [];
node.right = [];
node.Q = [];
node.W_index = [];
node.comp_Q = [];
node.trans_Q = [];
node.depth = 1;
node_cell{1,1} = node;
for i = 1:max_rows
    level_content = node_cell(i,:);
    level_node = cellfun('isempty', level_content);
    index = find(level_node == 0); %当前层所有的节点
    if isempty(index)
        break;
    end
    for sub_node_index = index
        sub_node = level_content{1, sub_node_index};
        [data_num,~] = size(sub_node.data);
        [med,max_dim_val,max_dim_cov_val] = maxd(sub_node.data,data_num);
        if max_dim_cov_val > threshold
            left_node = [];
            [lrow,~] = find(sub_node.data(:,max_dim_val) >= med);
            [left_node, sub_node] = setChildNodeInfo(left_node, sub_node, lrow, i);
            %node_cell{sub_node.depth, sub_node.index(1)} = sub_node;           
            
            
            right_node = [];
            [lrow,~] = find(sub_node.data(:,max_dim_val) < med);
            [right_node, sub_node] = setChildNodeInfo(right_node, sub_node, lrow, i);
            node_cell{sub_node.depth, sub_node.index(1)} = sub_node;
            left_node.parent = sub_node;
            right_node.parent = sub_node;
            node_cell{i + 1, left_node.index(1)} = left_node;
            node_cell{i + 1, right_node.index(1)} = right_node;
        else
            leaf_node_matrix = [leaf_node_matrix; sub_node];
        end
    end
end
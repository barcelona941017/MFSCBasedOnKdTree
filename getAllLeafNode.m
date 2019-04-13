function leaf_node_matrix = getAllLeafNode(current_node,thres,leaf_node_matrix)
if isstruct(current_node)
    [data_num,~]=size(current_node.data);
    [med,max_dim_val,max_dim_cov_val]=maxd(current_node.data,data_num);
    if max_dim_cov_val>thres
        [lrow,~]=find(current_node.data(:,max_dim_val) >= med);
        current_node.left.data=current_node.data(lrow,:);
        current_node.left.index=current_node.index(lrow);

        [rrow,~]=find(current_node.data(:,max_dim_val)<med);
        current_node.right.data=current_node.data(rrow,:);
        current_node.right.index=current_node.index(rrow);      
        if (isstruct(current_node.right))
            leaf_node_matrix = getAllLeafNode(current_node.right,thres,leaf_node_matrix);
        end
        if (isstruct(current_node.left))
            leaf_node_matrix =getAllLeafNode(current_node.left,thres,leaf_node_matrix);
        end
    else
        leaf_node_matrix=[leaf_node_matrix;current_node];
     end
end
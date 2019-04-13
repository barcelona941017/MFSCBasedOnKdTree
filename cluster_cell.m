function [node_cell_matrix,leaf_node_matrix]=cluster_cell(current_node,thres,node_cell_matrix,leaf_node_matrix)

if isstruct(current_node)
    [data_num,~]=size(current_node.data);
    [med,max_dim_val,max_dim_cov_val]=maxd(current_node.data,data_num);
    if max_dim_cov_val>thres
        current_node.left.parent=current_node;
        [lrow,~]=find(current_node.data(:,max_dim_val) >= med);
        current_node.left.data=current_node.data(lrow,:);
        current_node.left.index=current_node.index(lrow);
        current_node.left.length=length(lrow);
        current_node.left.left=[];
        current_node.left.right=[];
        current_node.left.Q=[];
        current_node.left.W_index=[];
        current_node.left.comp_Q=[];
        current_node.left.trans_Q=[];
        current_node.left.depth=current_node.depth+1;

        current_node.right.parent=current_node;
        [rrow,~]=find(current_node.data(:,max_dim_val)<med);
        current_node.right.data=current_node.data(rrow,:);
        current_node.right.index=current_node.index(rrow);
        current_node.right.length=length(rrow);
        current_node.right.right=[];
        current_node.right.left=[];
        current_node.right.Q=[];
        current_node.right.W_index=[];
        current_node.right.comp_Q=[];
        current_node.right.trans_Q=[];
        current_node.right.depth=current_node.depth+1;
        if (isstruct(current_node.right))
          [node_cell_matrix,leaf_node_matrix]=cluster_cell(current_node.right,thres,node_cell_matrix,leaf_node_matrix);
        end
        if (isstruct(current_node.left))
         [node_cell_matrix,leaf_node_matrix] =cluster_cell(current_node.left,thres,node_cell_matrix,leaf_node_matrix);
        end
        node_cell_matrix=[node_cell_matrix; current_node];
    else
        node_cell_matrix=[node_cell_matrix;current_node];
        leaf_node_matrix=[leaf_node_matrix;current_node];
     end
end

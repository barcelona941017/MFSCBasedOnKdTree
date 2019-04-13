function [leaf_node, sub_node] = setChildNodeInfo(leaf_node, sub_node, lrow, i)
leaf_node.data = sub_node.data(lrow,:);
leaf_node.index = sub_node.index(lrow);
leaf_node.length = length(lrow);
leaf_node.left = [];
leaf_node.right = [];
leaf_node.Q = [];
leaf_node.W_index = [];
leaf_node.comp_Q = [];
leaf_node.trans_Q = [];
leaf_node.depth = i + 1;
if leaf_node.index(1) == sub_node.index(1)
    sub_node.left = leaf_node;
else 
    sub_node.right = leaf_node;
end
%leaf_node.parent = sub_node;
end
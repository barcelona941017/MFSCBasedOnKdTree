function [IndiMat, order_of_node]= reprePointIndictorMatrix(data, W, Q_IndexTable,  kdTree_stru, Q_W_IndexTable,start_level, nbCluster)
[n,~] = size(data); %n数据的个数
max_level = floor(log2(n)) + 1;
W_index_saveStruct = cell(max_level, n); %用来存储从start_level开始每一层的W_index
if start_level > max_level
    return;
end
level = start_level;
while level > 1
    level_content = kdTree_stru(level,:);
    level_node = cellfun('isempty', level_content);
    index = find(level_node == 0); %当前层所有的节点
    
    if  level == start_level
        for i = index
            W_index = [];
            node = level_content{1,i};           
            if ~isempty(node.left)                                  %如果start_level的节点不是叶子节点
                node_flag = min(node.index);
                W_index_cell = Q_IndexTable(1, node_flag);               %通过Q_IndexTable来找到start_level中各节点的叶子节点的
                W_index_struct = W_index_cell{1,1};
                for j = 1:length(W_index_struct)
                    W_index = [W_index find(Q_W_IndexTable == W_index_struct(j).index(1))];
                end 
                W_index_saveStruct{level,node.index(1)} = W_index;         %start_level的W_index是Q_IndexTable给的。
                W_index_saveStruct{level - 1, node.parent.index(1)} = [W_index_saveStruct{level - 1, node.parent.index(1)} W_index];%将孩子节点的w信息传给父亲节点                
                nb_leafNode = length(W_index);                      %当前节点的叶子节点的个数
                node.comp_Q = eye(nb_leafNode, nb_leafNode);
                kdTree_stru{level,i}.comp_Q = eye(nb_leafNode, nb_leafNode);    %start_level的computeQ是单位阵 它的trans_Q又后面计算而来
            else                                                     %如果start_level的节点是叶子节点   
                [W_index_saveStruct, kdTree_stru] = processLeafNode(node, i, kdTree_stru, W_index_saveStruct, Q_IndexTable);
                continue;                                                                 %由于当前节点是叶子节点所以没有当前节点的comp_Q
            end  
            kdTree_stru = computerSubWandMerge(W, W_index, W_index_saveStruct, node, i, kdTree_stru, nbCluster);         %计算Indictor矩阵并存储在kdTree中
        end%for
        level = level - 1;
    else      %如果不是start_level                     
        for i = index
            node = level_content{1,i};  
            W_index = [];
            if ~isempty(node.left)                                  %如果start_level的节点不是叶子节点
                W_index = W_index_saveStruct{level, min(node.index)};      %非start_level层的W_index是下面传递上来的。
                W_index_saveStruct{level - 1, min(node.parent.index)} = [W_index_saveStruct{level - 1, min(node.parent.index)} W_index];  %把自己的W信息传给上面一层
                %W_index = [left_node_W_index right_node_W_index];   %通过Q_IndexTable来找到start_level中各节点的叶子节点的                      %这里comp_Q由下层提供
            else                                                     %如果start_level的节点是叶子节点
                [W_index_saveStruct, kdTree_stru] = processLeafNode(node, i, kdTree_stru, W_index_saveStruct, Q_IndexTable);
                continue;                                                                 %由于当前节点是叶子节点所以没有当前节点的comp_Q
            end  
            kdTree_stru = computerSubWandMerge(W, W_index, W_index_saveStruct, node, i, kdTree_stru, nbCluster);         
        end%for
        level = level - 1;    
    end
end
% top_node = kdTree_stru{1,1};
% left_leaf_posi = top_node.left.index(1);
% right_leaf_posi = top_node.right.index(1);
% left_leaf_W_index = W_index_saveStruct{top_node.depth + 1, left_leaf_posi};
% right_leaf_W_index = W_index_saveStruct{top_node.depth + 1, right_leaf_posi};
% W_index = [left_leaf_W_index right_leaf_W_index];

order_of_node = W_index_saveStruct{1,1};
level_content = kdTree_stru(level,:);
final_node = cellfun('isempty',level_content);
final_node_index = find(final_node==0);
IndiMat = [];
for i = final_node_index
    Node = level_content{1,i};
    IndiMat = Node.comp_Q;
end

function [IndiMat, order_of_node]= reprePointIndictorMatrix(data, W, Q_IndexTable,  kdTree_stru, Q_W_IndexTable,start_level, nbCluster)
[n,~] = size(data); %n���ݵĸ���
max_level = floor(log2(n)) + 1;
W_index_saveStruct = cell(max_level, n); %�����洢��start_level��ʼÿһ���W_index
if start_level > max_level
    return;
end
level = start_level;
while level > 1
    level_content = kdTree_stru(level,:);
    level_node = cellfun('isempty', level_content);
    index = find(level_node == 0); %��ǰ�����еĽڵ�
    
    if  level == start_level
        for i = index
            W_index = [];
            node = level_content{1,i};           
            if ~isempty(node.left)                                  %���start_level�Ľڵ㲻��Ҷ�ӽڵ�
                node_flag = min(node.index);
                W_index_cell = Q_IndexTable(1, node_flag);               %ͨ��Q_IndexTable���ҵ�start_level�и��ڵ��Ҷ�ӽڵ��
                W_index_struct = W_index_cell{1,1};
                for j = 1:length(W_index_struct)
                    W_index = [W_index find(Q_W_IndexTable == W_index_struct(j).index(1))];
                end 
                W_index_saveStruct{level,node.index(1)} = W_index;         %start_level��W_index��Q_IndexTable���ġ�
                W_index_saveStruct{level - 1, node.parent.index(1)} = [W_index_saveStruct{level - 1, node.parent.index(1)} W_index];%�����ӽڵ��w��Ϣ�������׽ڵ�                
                nb_leafNode = length(W_index);                      %��ǰ�ڵ��Ҷ�ӽڵ�ĸ���
                node.comp_Q = eye(nb_leafNode, nb_leafNode);
                kdTree_stru{level,i}.comp_Q = eye(nb_leafNode, nb_leafNode);    %start_level��computeQ�ǵ�λ�� ����trans_Q�ֺ���������
            else                                                     %���start_level�Ľڵ���Ҷ�ӽڵ�   
                [W_index_saveStruct, kdTree_stru] = processLeafNode(node, i, kdTree_stru, W_index_saveStruct, Q_IndexTable);
                continue;                                                                 %���ڵ�ǰ�ڵ���Ҷ�ӽڵ�����û�е�ǰ�ڵ��comp_Q
            end  
            kdTree_stru = computerSubWandMerge(W, W_index, W_index_saveStruct, node, i, kdTree_stru, nbCluster);         %����Indictor���󲢴洢��kdTree��
        end%for
        level = level - 1;
    else      %�������start_level                     
        for i = index
            node = level_content{1,i};  
            W_index = [];
            if ~isempty(node.left)                                  %���start_level�Ľڵ㲻��Ҷ�ӽڵ�
                W_index = W_index_saveStruct{level, min(node.index)};      %��start_level���W_index�����洫�������ġ�
                W_index_saveStruct{level - 1, min(node.parent.index)} = [W_index_saveStruct{level - 1, min(node.parent.index)} W_index];  %���Լ���W��Ϣ��������һ��
                %W_index = [left_node_W_index right_node_W_index];   %ͨ��Q_IndexTable���ҵ�start_level�и��ڵ��Ҷ�ӽڵ��                      %����comp_Q���²��ṩ
            else                                                     %���start_level�Ľڵ���Ҷ�ӽڵ�
                [W_index_saveStruct, kdTree_stru] = processLeafNode(node, i, kdTree_stru, W_index_saveStruct, Q_IndexTable);
                continue;                                                                 %���ڵ�ǰ�ڵ���Ҷ�ӽڵ�����û�е�ǰ�ڵ��comp_Q
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

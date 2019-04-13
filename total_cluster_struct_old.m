function [total_cluster_struct,leaf_node_matrix]=total_cluster_struct_old(data,thres,depth)
data_num=length(data);
current_node.data=data;
current_node.index=1:data_num;
current_node.parent=[];
current_node.left=[];
current_node.right=[];
current_node.length=data_num;
current_node.Q=[];
current_node.comp_Q=[];
current_node.trans_Q=[];
current_node.W_index=[];
current_node.depth=1;
node_cell_matrix=[];
leaf_node_matrix=[];

%[node_cell,leaf_node_matrix_1] = cluster_cell_loop(thres, data);

[node_cell_matrix,leaf_node_matrix]=cluster_cell(current_node,thres,node_cell_matrix,leaf_node_matrix);
node_cell_num=length(node_cell_matrix);

for i=1:node_cell_num
   node_cell_matrix(i).leaf_node_index=[];
    for j=1:length(leaf_node_matrix)
       if(node_cell_matrix(i).depth==depth&&all(ismember(leaf_node_matrix(j).index,node_cell_matrix(i).index))) %判断节点是否是那个节点的一个子集
            temp.index=leaf_node_matrix(j).index;
            node_cell_matrix(i).leaf_node_index=[node_cell_matrix(i).leaf_node_index;temp];
       end
    end
end


%total_cluster_struct_row=floor(log2(data_num))+1;
total_cluster_struct_row=6;

%total_cluster_struct_row=10;
total_cluster_struct=cell(total_cluster_struct_row,data_num);
for i=1:node_cell_num
    current_node_row=node_cell_matrix(i).depth;
    current_node_col=min(node_cell_matrix(i).index);
    total_cluster_struct{current_node_row,current_node_col}=node_cell_matrix(i);
end

%[total_cluster_struct_nonull_row,total_cluster_struct_nonull_col]=find(~cellfun('isempty',total_cluster_struct(1:depth,:))==1);
%a=~cellfun('isempty',total_cluster_struct(1:depth,:));
for i=1:total_cluster_struct_row
    for j=1:data_num
         if (isstruct(total_cluster_struct{i,j})&&isstruct(total_cluster_struct{i,j}.left)&&min(total_cluster_struct{i,j}.left.index)~=j)
             temp=total_cluster_struct{i,j}.right;
             total_cluster_struct{i,j}.right=total_cluster_struct{i,j}.left;
             total_cluster_struct{i,j}.left=temp;
         end
    end
end
for i=2:depth
    for j=1:data_num
        if (isstruct(total_cluster_struct{i,j}))
            total_cluster_struct{i,j}.parent=total_cluster_struct{i-1,min(total_cluster_struct{i,j}.parent.index)};
        end
    end
end






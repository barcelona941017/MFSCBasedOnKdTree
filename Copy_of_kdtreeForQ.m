function Q = Copy_of_kdtreeForQ(I,kd_t,W,base_level,nbcluster)
[r,c] = size(I);
max_level = log2(r);
%dataNcut.valeurMin=1e-6;
if base_level > max_level
    return
end
level = base_level;                                             %这里的level都是合并到的层
while level > 1
    level_content = kd_t(level,:);
    b = cellfun('isempty',level_content);
    index = find(b==0);
    %找到所有不为空的位置
if level == base_level                                    %init level的做法
    for i = index
        q_parent = [];
        list = {};                                       %用来存放指定层某一位置中的点的包含的所有叶节点
        node = level_content{1,i};                              %node是父节点
        if ~isempty(node.left)                                  %如果这个节点不是叶子节点，则找个这个节点下的所有子节点，构成Q
            list = returnAllLeaves(node,list);
            c = cellfun('isempty',list);                        %list,父节点的所有叶子节点的集合
            index_list = find(c == 0);
            for j = index_list                                  %遍历每一个叶子节点
                leaf_node = list{1,j};
                for k = leaf_node                               %叶子节点是一个向量，找出其在父节点的位置
                    q_leaf = zeros(1,node.length);
                    for leaf_index = k.index
                        q_leaf(1,node.index == leaf_index) = 1;
                    end
                end
                q_parent = [q_parent;q_leaf];                   %所有叶子节点Q合并为父节点的Q           
            end
            [row,col] = size(q_parent);
            Qt = q_parent.*q_parent;
            totalQ = sum(Qt,2);
            for k =1:row  
               q_parent(k,:) = q_parent(k,:)/sqrt(totalQ(k));
            end
            node.comp_Q = q_parent;
            kd_t{level,i}.comp_Q = q_parent;
            %Q = q_parent;
            %return;
            
            %kd_t{level,i} = node;
            %level_content{1,i} = node;
            %comp_Q用于计算这个点的特征向量
            %trans_Q用于传递给上一层
        else                                                    %如果这个节点是叶子节点，则自己就是一个Q
          par_size = node.parent.length;                        %data换成index
          q_leaf = zeros(1,par_size);
          for mm = node.index
               q_leaf(1,node.parent.index == mm) = 1;
          end
          [row,col] = size(q_leaf);
          Qt = q_leaf.*q_leaf;
          totalQ = sum(Qt,2);
          for k =1:row  
             q_leaf(k,:) = q_leaf(k,:)/sqrt(totalQ(k));
          end
          node_parent = node.parent;
          parent_posi = node_parent.index(1,1);
          kd_t{level,i}.parent.comp_Q = [kd_t{level,i}.parent.comp_Q;q_parent];
          kd_t{level - 1,parent_posi}.comp_Q = [kd_t{level - 1,parent_posi}.comp_Q;q_leaf];
          %kd_t{level,i}.trans_Q = q_leaf;
          %kd_t{level,i} = node;
          %level_content{1,i} = node;
          continue;
        end
        sub_W = W(node.index,node.index);
        %sub_W = sparsifyc(sub_W,dataNcut.valeurMin);
        [wr,wc] = size(sub_W);
        offset = 5e-1;
        d = sum(abs(sub_W),2);
        d = d + offset * 2;
        eps = 0.000001;
        Dinvsqrt = 1./sqrt(d+eps);
        sub_W = spdiags(d,0,wr,wc)-sub_W;
        Pi = spmtimesd(sub_W,Dinvsqrt,Dinvsqrt);
        %Pi = spdiags(Dinvsqrt,0,wr,wc)*(spdiags(d,0,wr,wc)-sub_W)*spdiags(Dinvsqrt,0,wr,wc);
        PNew = node.comp_Q*Pi*node.comp_Q'; 
        [eigenVector,eigenValue] = eigs(PNew,nbcluster,'sm');                
        eigenVector = real(eigenVector);
        eigenVector = node.comp_Q'*eigenVector;
        chil_in_par_index = [];
        for ii = node.index
            chil_in_par_index = [chil_in_par_index ,find(node.parent.index == ii)];
        end
        [evs_r,evs_c] = size(eigenVector);
        q_parent = zeros(evs_c,node.parent.length);
        q_parent(:,chil_in_par_index) = eigenVector';
        node_parent = node.parent;
        parent_posi = node_parent.index(1,1);
        temp = kd_t{level - 1,parent_posi}.comp_Q;
        kd_t{level,i}.parent.comp_Q = [temp;q_parent];
        temp2 = kd_t{level - 1,parent_posi}.comp_Q;
        kd_t{level - 1,parent_posi}.comp_Q = [temp2;q_parent];
        %kd_t{level,i} = node;
        %level_content{1,i} = node;
    end
    level = level - 1;
else                                                                       %coaser level的做法
    for i = index
        node = level_content{1,i};
        if ~isempty(node.left)                                             %还是同样的判断自己是否是叶子节点
            %kd_t{level,i}.comp_Q = [node.left.trans_Q;node.left.trans_Q]; 
            %node.comp_Q = [node.left.trans_Q;node.left.trans_Q];       %获取左右孩子传递的Q
            sub_W = W(node.index,node.index);
            %sub_W = sparsifyc(sub_W,dataNcut.valeurMin);
            [wr,wc] = size(sub_W);
            offset = 5e-1;
            d = sum(abs(sub_W),2);
            d = d + offset * 2;
            eps = 0.000001;
            Dinvsqrt = 1./sqrt(d+eps);
            sub_W = spdiags(d,0,wr,wc)-sub_W;
            Pi = spmtimesd(sub_W,Dinvsqrt,Dinvsqrt);
            %Pi = spdiags(Dinvsqrt,0,wr,wc)*(spdiags(d,0,wr,wc)-sub_W)*spdiags(Dinvsqrt,0,wr,wc);
            PNew = node.comp_Q*Pi*node.comp_Q'; 
            [eigenVector,eigenValue] = eigs(PNew,nbcluster,'sm');                
            eigenVector = real(eigenVector);
            eigenVector = node.comp_Q'*eigenVector;
            chil_in_par_index = [];
            for ii = node.index
                chil_in_par_index = [chil_in_par_index ,find(node.parent.index == ii)];
            end
            [evs_r,evs_c] = size(eigenVector);
            q_parent = zeros(evs_c,node.parent.length);
            q_parent(:,chil_in_par_index) = eigenVector';
            node_parent = node.parent;
            parent_posi = node_parent.index(1,1);
            temp = kd_t{level - 1,parent_posi}.comp_Q;
            kd_t{level,i}.parent.comp_Q = [temp;q_parent];
            temp2 = kd_t{level - 1,parent_posi}.comp_Q;
            kd_t{level - 1,parent_posi}.comp_Q = [temp2;q_parent];
            %kd_t{level,i}.trans_Q = q_parent;
            %level_content{1,i} = node;
        else                                                               
            par_size = node.parent.length;                                   %如果没有左右孩子，自己生成向上传递的Q，所以要知道父亲节点的信息
            q_leaf = zeros(1,par_size);
            for k = node.index
                q_leaf(1,node.parent.index == k) = 1;                          %自己的值在父节点的位置,生成传递的q_leaf
            end
            q_leaf = zeros(1,par_size);
            for mm = node.index
               q_leaf(1,node.parent.index == mm) = 1;
            end
            [row,col] = size(q_leaf);
            Qt = q_leaf.*q_leaf;
            totalQ = sum(Qt,2);
            for k =1:row  
                q_leaf(k,:) = q_leaf(k,:)/sqrt(totalQ(k));
            end
            node_parent = node.parent;
            parent_posi = node_parent.index(1,1);
            kd_t{level,i}.parent.comp_Q = [kd_t{level,i}.parent.comp_Q;q_leaf];
            kd_t{level - 1,parent_posi}.comp_Q = [kd_t{level - 1,parent_posi}.comp_Q;q_leaf];
            %kd_t{level,i}.trans_Q = q_leaf;
            %kd_t{level,i} = node;
            %level_content{1,i} = node;
        end
    end
    level = level - 1;
end
end
level_content = kd_t(level,:);
b = cellfun('isempty',level_content);
index = find(b==0);
Q = [];
for i = index
    Node = level_content{1,i};
    Q = Node.comp_Q;
end

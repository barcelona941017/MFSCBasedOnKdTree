function Q = Copy_of_kdtreeForQ(I,kd_t,W,base_level,nbcluster)
[r,c] = size(I);
max_level = log2(r);
%dataNcut.valeurMin=1e-6;
if base_level > max_level
    return
end
level = base_level;                                             %�����level���Ǻϲ����Ĳ�
while level > 1
    level_content = kd_t(level,:);
    b = cellfun('isempty',level_content);
    index = find(b==0);
    %�ҵ����в�Ϊ�յ�λ��
if level == base_level                                    %init level������
    for i = index
        q_parent = [];
        list = {};                                       %�������ָ����ĳһλ���еĵ�İ���������Ҷ�ڵ�
        node = level_content{1,i};                              %node�Ǹ��ڵ�
        if ~isempty(node.left)                                  %�������ڵ㲻��Ҷ�ӽڵ㣬���Ҹ�����ڵ��µ������ӽڵ㣬����Q
            list = returnAllLeaves(node,list);
            c = cellfun('isempty',list);                        %list,���ڵ������Ҷ�ӽڵ�ļ���
            index_list = find(c == 0);
            for j = index_list                                  %����ÿһ��Ҷ�ӽڵ�
                leaf_node = list{1,j};
                for k = leaf_node                               %Ҷ�ӽڵ���һ���������ҳ����ڸ��ڵ��λ��
                    q_leaf = zeros(1,node.length);
                    for leaf_index = k.index
                        q_leaf(1,node.index == leaf_index) = 1;
                    end
                end
                q_parent = [q_parent;q_leaf];                   %����Ҷ�ӽڵ�Q�ϲ�Ϊ���ڵ��Q           
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
            %comp_Q���ڼ�����������������
            %trans_Q���ڴ��ݸ���һ��
        else                                                    %�������ڵ���Ҷ�ӽڵ㣬���Լ�����һ��Q
          par_size = node.parent.length;                        %data����index
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
else                                                                       %coaser level������
    for i = index
        node = level_content{1,i};
        if ~isempty(node.left)                                             %����ͬ�����ж��Լ��Ƿ���Ҷ�ӽڵ�
            %kd_t{level,i}.comp_Q = [node.left.trans_Q;node.left.trans_Q]; 
            %node.comp_Q = [node.left.trans_Q;node.left.trans_Q];       %��ȡ���Һ��Ӵ��ݵ�Q
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
            par_size = node.parent.length;                                   %���û�����Һ��ӣ��Լ��������ϴ��ݵ�Q������Ҫ֪�����׽ڵ����Ϣ
            q_leaf = zeros(1,par_size);
            for k = node.index
                q_leaf(1,node.parent.index == k) = 1;                          %�Լ���ֵ�ڸ��ڵ��λ��,���ɴ��ݵ�q_leaf
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

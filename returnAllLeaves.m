function list = returnAllLeaves(Node,list)
if isempty(Node.left) %�ṹ�����������Էǽṹ���������
    list = [list,Node];
   % return list;
else
    list = returnAllLeaves(Node.left,list);
    list = returnAllLeaves(Node.right,list);
end
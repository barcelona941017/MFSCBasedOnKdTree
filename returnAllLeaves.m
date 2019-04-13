function list = returnAllLeaves(Node,list)
if isempty(Node.left) %结构体内容引用自非结构体数组对象。
    list = [list,Node];
   % return list;
else
    list = returnAllLeaves(Node.left,list);
    list = returnAllLeaves(Node.right,list);
end
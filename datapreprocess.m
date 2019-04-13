  
function [ground,res]=datapreprocess(I,res,nbSegments)
ground = logical(I == 255);
[r,c] = size(res);
count = zeros(1,nbSegments);
x = find(ground == 1);
y = find(ground ~= 1);
for i = 1:length(x)
    label_res = res(x(i));
    count(label_res) = count(label_res) + 1;
end
c = find(count == max(count));
res(x) = logical(res(x) == c);  
res(y) = logical(res(y) == c);
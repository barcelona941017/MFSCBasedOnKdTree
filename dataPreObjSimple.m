function [ground,res_new]=dataPreObjSimple(golden,res,nbSegment)
[r,c] = size(res);
golden = imread(golden);
g_red = double(golden(:,:,1) > 240);
g_red_rz = uint8(g_red);
%g_red_rz = imresize(g_red,[r, c],'bicubic');
ground = zeros(r,c);
ground(g_red_rz == 1) = 1;
count = zeros(1,nbSegment);
x = find(g_red_rz == 1);
y = find(g_red_rz ~= 1);

for i = 1:length(x)
    label_res = res(x(i));
    count(label_res) = count(label_res) + 1;
end
res_red = find(count == max(count));
res_new = zeros(r,c);
res_new(res == res_red) = 1;

            
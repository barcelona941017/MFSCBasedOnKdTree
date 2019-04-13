function [ground,res_new]=dataPreObj2(golden,res,nbSegment)
[r,c] = size(res);
golden = imread(golden);
g_red = double(golden(:,:,1) < 10);
g_blue = double(golden(:,:,3) < 10);
g_red = uint8(g_red);
g_blue = uint8(g_blue);
g_red_rz = imresize(g_red,[r, c],'bicubic');
g_blue_rz = imresize(g_blue,[r, c],'bicubic');
ground = zeros(r,c);
ground(g_red_rz == 1) = 1;
ground(g_blue_rz == 1) = 2;
count = zeros(1,nbSegment);
x = find(g_red_rz == 1);
y = find(g_red_rz ~= 1);

for i = 1:length(x)
    label_res = res(x(i));
    count(label_res) = count(label_res) + 1;
end

res_red = find(count == max(count));

count = zeros(1,7);
x = find(g_blue_rz == 1);
y = find(g_blue_rz ~= 1);

for i = 1:length(x)
    label_res = res(x(i));
    count(label_res) = count(label_res) + 1;
end

res_blue = find(count == max(count));

res_new = zeros(r,c);
res_new(res == res_red) = 1;
res_new(res == res_blue) = 2;

            
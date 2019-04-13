function [img,img_r,img_c] = NormalizedImg(I)

[r,c,h] = size(I);
[posi_y,posi_x] = meshgrid(1:c,1:r);
data_posi = [posi_x(:),posi_y(:)];
img_reshape = reshape(I,r*c,h);
type = 1;
if type == 1
    img = [data_posi img_reshape];
end
if type == 2
    img = [data_posi img_reshape(:,1)];
end
if type == 3
    img = img_reshape;
end
img = double(img);
%img = double(img_reshape);
img_r = r;
img_c = c;
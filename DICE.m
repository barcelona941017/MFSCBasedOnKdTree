function Dice=DICE(ground,res)
    [r,c] = size(ground);  
    ground = reshape(ground,1,r*c);
    res = reshape(res,1,r*c);
    dot_XY = dot(ground,res);
    ground_len = length(find(ground == 1));
    %ground_len = length(find(ground == 0));
    res_len = length(find(res == 1));
    %res_len = length(find(res ~= 0 ));
    Dice = 2*dot_XY / (ground_len + res_len);
end
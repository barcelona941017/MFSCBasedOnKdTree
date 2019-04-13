function Dice=DICE2Obj(ground,res)
    ground_1(ground == 1) = 1;
    ground_1(ground ~= 1) = 0;
    res_1(res == 1) = 1;
    res_1(res ~= 1) = 0;
    Dice_1 = DICE(ground_1,res_1);
    
    ground_2(ground == 2) = 1;
    ground_2(ground ~= 2) = 0;
    res_2(res == 2) = 1;
    res_2(res ~= 2) = 0;
    Dice_2 = DICE(ground_2,res_2);
    
    Dice = (Dice_1 + Dice_2) / 2;
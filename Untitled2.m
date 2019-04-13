label1 = zeros(208,1);
for i = 1:208
    switch sonar1{i}
        case 'R'
            label1(i) = 1;
        case 'M'
            label1(i) = 2;
        case 'WINDOW'
            label1(i) = 5;
        case 'CEMENT'
            label1(i) = 4;
        case 'FOLIAGE'
            label1(i) = 3;
        case 'SKY'
            label1(i) = 2;
        case 'BRICKFACE'
            label1(i) = 1;
    end
end
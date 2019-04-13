function [acc,ri,dice] = showACCandSaveRes(sourceimage,res_seglabel,filename_golden,segmentType,nbSegments)
golden = imread(filename_golden);
if(segmentType == 1)
    [I2,B] = datapreprocess(golden,res_seglabel,nbSegments);
else if segmentType == 2
    [I2,B] = dataPreObj2(filename_golden,res_seglabel,nbSegments);
    end
end

if segmentType == 3
    [I2,B] = dataPreObjSimple(filename_golden,res_seglabel,nbSegments);
end

 B = double(B);
 I2 = double(I2);
%ExtractionTarget(B, sourceimage);
bw = edge(B,0.01);
imshow(sourceimage),
hold on;
[B_1,L] = bwboundaries(B,'noholes');
for i = 1:length(B_1)
    boundary = B_1{i};
    plot(boundary(:,2), boundary(:,1), 'R', 'LineWidth', 2)
end

bw = edge(B,0.01);
%imwrite(sourceimage,'paperImage/source.jpg');
% J1=showmask(sourceimage,imdilate(bw,ones(2,2)));
% imwrite(J1, '放入毕业论文中的结果/oko.png'),


%saveas(J1,'../results/data/target.png')
%imshow(J1);
acc = ACC(I2,B);
if(segmentType == 1 || segmentType == 3)
    dice = DICE(I2,B); 
else
    dice = DICE2Obj(I2,B);
end
ri = RI(I2,B);
disp(['ACC = ' num2str(acc)]);
disp(['DICE = ' num2str(dice)]);
disp(['RI = ' num2str(ri)]);
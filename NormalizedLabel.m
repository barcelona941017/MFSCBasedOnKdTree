function n_Seg_Label = NormalizedLabel(gTruth_label,Seg_label,nbSegment)
%different_num_ncut=different_ACC(gTruth_label,Seg_label,nbSegment);
[ground,different_num]=different(gTruth_label,Seg_label,nbSegment);

for i=1:nbSegment
    index = ground(i);
    different_num(different_num(:,i)==1,i) = index;
end
different_num = sum(different_num,2);
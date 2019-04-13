function ACC=ACC(S1,S2)
%S1:ground truth
%S2:res
obj1 = find(S1==S2&S2==1);
obj2 = find(S1==S2&S2==2);
ground = find(S1==S2&S2==0);
[R,C]=size(S1);
%B=find(S1==1);
ACC=(length(obj1)+length(obj2) + length(ground))/(R*C);
end


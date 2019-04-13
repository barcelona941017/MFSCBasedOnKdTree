function [t,Index_B]=different(A,B,k)
unique_index=unique(A);
Index_A=zeros(length(A),k);
B_process=zeros(length(A),1);
for i=1:k
    label=unique_index(i);
    Index_A(find(A==label),i)=1;
end
unique_index=unique(B);
Index_B=zeros(length(A),k);
for i=1:k
    label=unique_index(i);
    Index_B(find(B==label),i)=1;
end
%s=zeros(length(B),k);
t=[];
for i=1:k
    sum_A=[];
    for j=1:k
            sum_1=sum(abs(Index_B(:,i)-Index_A(:,j)));
            sum_A=[sum_A,sum_1];
    end
      t1=find(sum_A==min(sum_A));
      t=[t,t1];
end
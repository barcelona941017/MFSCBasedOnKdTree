function different_num=different_ACC(A,B,k)
unique_index=unique(A);
Index_A=zeros(150,k);
for i=1:k
    label=unique_index(i);
    Index_A(find(A==label),i)=1;
end
unique_index=unique(B);
Index_B=zeros(150,k);
for i=1:k
    label=unique_index(i);
    Index_B(find(B==label),i)=1;
end
s=zeros(length(B),k);
for i=1:k
    %s=[];
    s1=abs(Index_A(:,i)-Index_B(:,1));
    sum_A=sum(abs(Index_A(:,i)-Index_B(:,1)));
    for j=2:k
        if(sum_A>sum(abs(Index_A(:,i)-Index_B(:,j))));
            s1=abs(Index_A(:,i)-Index_B(:,j));
            sum_A=sum(abs(Index_A(:,i)-Index_B(:,j)));
        end
    end
    s(:,i)=s1;
end
different_num1=sum(s,2);
different_num=length(find(different_num1~=0));
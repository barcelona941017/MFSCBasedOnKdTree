function [med,maxDimVal,maxDimCovVal]=maxd(data,n)
%med:�Ǹ���󷽲��ά���е����ݵ�ƽ��ֵ
%maxdimval:ӵ����󷽲��ά��
%maxdimcovval:��ά��������ά�ȷ���
A=diag(cov(data));
if length(A)==1
    maxDimCovVal=0;
    maxDimVal=0;
    med=0;
else 
    maxDimCovVal=max(A);
    maxDimVal=min(find(A==maxDimCovVal));
    med=sum(data(:,maxDimVal))/n;
end
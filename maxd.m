function [med,maxDimVal,maxDimCovVal]=maxd(data,n)
%med:那个最大方差的维度中的数据的平均值
%maxdimval:拥有最大方差的维度
%maxdimcovval:各维度中最大的维度方差
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
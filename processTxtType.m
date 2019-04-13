%function [data,groundtruth] = processTxtType(filename)
%fileID = fopen(filename);
matData = cell2mat(magic04(1:19020,11));


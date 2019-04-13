function readFileData
fileID = fopen('数据集/vowel-context.txt'); % 该数据文件需在当前目录下
C = textscan(fileID, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'delimiter', ' '); % 返回cell格式的数据 %f个数为特征个数
fclose(fileID);
source_data = cell2mat(C(1:4)); % 将cell格式转换成mat格式
wine = source_data(:, 1:4); % 第一列是类标签，去掉即可


label_c = C{11};
label = zeros(19020,1);
for i =1:19020
    if(strcmp(label_c{i},'g'))
        label(i) = 1;
    else if(strcmp(label_c{i},'h'))
         label(i) = 2;
        else if(strcmp(label_c{i},'Iris-virginica'))
                label(i) = 3;
            end
        end
    end
end
pause;
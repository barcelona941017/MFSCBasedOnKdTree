function readFileData
fileID = fopen('���ݼ�/vowel-context.txt'); % �������ļ����ڵ�ǰĿ¼��
C = textscan(fileID, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'delimiter', ' '); % ����cell��ʽ������ %f����Ϊ��������
fclose(fileID);
source_data = cell2mat(C(1:4)); % ��cell��ʽת����mat��ʽ
wine = source_data(:, 1:4); % ��һ�������ǩ��ȥ������


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
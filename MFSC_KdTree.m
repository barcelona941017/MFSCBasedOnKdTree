function MFSC_KdTree(data_filename, threshold,nbCluster,start_level,data_type,label_filename)


%% process visiable data
if data_type == 1
    data_struct_2 = load(data_filename);
    data_2 = data_struct_2.XX;
    data = data_2{3};
else if data_type == 2
        I = imread(data_filename);
        I = medfilt3_diy(I,[3,3]);
        [data,img_r,img_c] = NormalizedImg(I);
    end
end
if data_type == 3
    data = load(data_filename);
    data = data.source_data;
    label = load(label_filename);
    label = label.label;
end
[r,c] = size(data);
if(r < c)
    data = data';
end



%这里的data列表示data的数目
%figure(1);clf;
%plot(data(:,1),data(:,2),'ks', 'MarkerFaceColor','k','MarkerSize',5); axis image; hold on; 

%% process invisiable data
%  data_struct_2 = load(data_filename);
%  data = data_struct_2.source_data;
 

 



%% procss invisiable data
%data_2 = data_struct_2.matData;
% temp_data = data_2;
% data = data_2';
% [m,n]=size(data_2);
% for i = 1:n
% 
%     data_2(:,i)=data_2(:,i)/norm(data_2(:,i));
% 
% end
% temp_data = data_2;
% data = data_2';

n = length(data);                %数据的数目

% tic;
% [kdTree_stru, total_leaf_node]=total_cluster_struct_old(data, threshold, start_level);
% toc;
flag = 1;%1表示fsc；其他表示mfsc
tic;
if flag == 1
    SegLabel = ProcessDatasetByFSC(data, threshold, nbCluster, n);
    
else
    SegLabel = ProcessDatasetByMFSC(data, threshold, start_level, nbCluster, n);
end
toc;

if data_type == 3
    SegLabel = SegLabel';
    nmi_score = nmi(label, SegLabel) % Calculate NMI
    accuracy_score = accuracy(label, SegLabel) % Calculate accuracy
end




if data_type == 1
    cluster_color = ['rgbmyc'];
    figure(2);clf;
    
    data = data';
    for j = 1:nbCluster,
        id = find(SegLabel == j);
        plot(data(1,id),data(2,id),[cluster_color(j),'s'], 'MarkerFaceColor',cluster_color(j),'MarkerSize',5); hold on; 
    end
    axis off;
    hold off; axis image;
end

if data_type == 2
    SegLabel = reshape(SegLabel,img_r,img_c);
    imagesc(SegLabel);
     showSegLabel = (255/nbCluster) * SegLabel;
     showSegLabel = uint8(showSegLabel);
     figure(11),
     imshow(showSegLabel);
     imwrite(showSegLabel, 'C:\Users\Administrator\Desktop\分割结果\gray.png');
    segmentType = 3;
    [ACC,RI,DICE] = showACCandSaveRes(I,SegLabel,label_filename,segmentType,nbCluster);
    
end
disp('This is the clustering result');
disp('The demo is finished.');

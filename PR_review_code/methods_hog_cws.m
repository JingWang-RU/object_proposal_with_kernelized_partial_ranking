
clear;
methods = {'Rantalankila','CPMC','endres','geodeic','rigor'};
% for hog
cellSize = 8;
wid = 50;
hig = 60;
% for cws
K = 1024;  %256;%256;
b = 8;     %4;
num_box = 5000;
for m = 5:5%length(methods)
    m
    method =  methods{m};%'m_rs';%'EB';%'MCG';%'SS';
    method_fold = ['F:/Jing/proposal/' method];
    savefold = [ method_fold '/hog_cws_test/'];
    if ~exist(savefold,'dir')
        mkdir(savefold);
    end
    fold = './';%save the K,b matrix
    img_fold = './JPEGImages/';
    phase = 'test';
    % rcnn_fold = 'F:/Jing/Tool/rcnn-master/rcnn-master/';
    mat_fold = [method_fold '/mat/'];%[rcnn_fold 'data/selective_search_data/voc_2007_' phase '.mat'];
    
    % train 500, test 100
    load('./voc_2007_test.mat');
    clear boxes;
    for i = 1 : length(images)
        i
        file_name = images{i};
        save_file = [savefold '/CWS_' file_name '.mat'];
        if ~exist(save_file,'file')
            %     load image file SS use the box in rcnn_master
            box_file = [mat_fold file_name(1:4) '/' file_name '.mat'];
            box_mat = load(box_file);
            if iscell(box_mat.boxes)
               bboxes = box_mat.boxes{3};
               cur_box = bboxes(1:min(size(bboxes,1), num_box),:);
            else
                bboxes = box_mat.boxes;
                cur_box = bboxes(1:min(size(bboxes,1), num_box),:);
            end
            
            img_file = [img_fold file_name '.jpg'];
            imgf = imread(img_file);
            [hog_time hogImg] = box_to_hog(imgf, cur_box, cellSize, wid, hig);
            D = size(hogImg,2);
            [cws_time I_test] = anyfeature_to_cws(hogImg,K,D,b);
            clear hogImg;
            
            save(save_file,'I_test','cws_time','hog_time','-v7.3');
        end
    end
end

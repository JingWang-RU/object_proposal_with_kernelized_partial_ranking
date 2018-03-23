% load train data with hog feature
% vlfeat toolbox/vl_setup
% call example
clear;
addpath('../Tool/');
method = 'SS';%'BING';%'m_rs';%'EB';%'MCG';%
method_fold = ['F:/Jing/' method];
phase = 'test';
savefold = [ method_fold '/hog_chi2_' phase '/'];
if ~exist([savefold '/'], 'dir')
    mkdir([savefold '/']);
end
num_test = 4952;
% num_box = 2000;
% for hog
cellSize = 8;
wid = 50;
hig = 60;
img_fold = './JPEGImages/';
mat_fold = [method_fold '/mat/'];%[rcnn_fold 'data/selective_search_data/voc_2007_' phase '.mat'];
% rmat = load(mat_file);
% method = 'random_gaussian';%'edge';
% train 500, test 100
load('./voc_2007_test.mat');
clear boxes;
num_box = 5000;
% tk = 10; % TOP k
tk_seq = [10,20,40,60,80,90,100];

for i = 1 : length(images)
    i
    file_name = images{i};
    save_file = [savefold '/chi2_' phase '_' method '_' file_name '.mat'];
    if ~exist(save_file,'file')
        hog_file = [method_fold '/hog_voc_' phase '/HOG_' file_name '.mat'];
        if exist(hog_file,'file')
            load(hog_file);
        else
            %     load image file SS use the box in rcnn_master
            box_file = [mat_fold file_name(1:4) '/' file_name '.mat'];
            box_mat = load(box_file);
            cur_box = box_mat.boxes(1:min(size(box_mat.boxes,1), num_box),:);
            %         cur_box = rmat.boxes{i};
            
            img_file = [img_fold file_name '.jpg'];
            imgf = imread(img_file);
            %         [hog_time hogImg] = box_to_hog(imgf, cur_box(:,[2 1 4 3]), cellSize, wid, hig);
            [hog_time hogImg] = box_to_hog(imgf, cur_box, cellSize, wid, hig);
        end
        if exist('hogr','var')
           hogImg=hogr;
           clear hogr;
        end
        tic;               
        I_test = vl_homkermap(hogImg,.6);
        chi_time = toc;         
        clear hogImg;        
        save(save_file,'I_test','chi_time','-v7.3');
        %           'hog_time',  'iou_matr','tk_seq','I_test',,'pos_ind_img','neg_ind_img','-v7.3');
    end
end
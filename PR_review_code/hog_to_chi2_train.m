% load train data with hog feature to generate chi2 feature
% vlfeat toolbox/vl_setup

clear;
addpath('../Tool/');

method = 'SS';
phase = 'train';
savefold = ['F:/Jing/' method '/hog_chi2_' phase '/'];
if ~exist([savefold  '/'], 'dir')
    mkdir([savefold  '/']);
end
hogfold = ['F:/Jing/' method '/hog_voc_' phase '/'];
mat_fold = ['F:/Jing/' method '/mat/'];
% load train val test index imgName, proposal
% proposal:.boxes [y1 x1 y2 x2] imgName 000005
% load('../Images/VOC2007/GtVOC07trainval.mat');%mercury

load('./GtVOC07trainval.mat');%mercury
num_train = 400;
num_box = 2000;
cur_id = imgName(1:num_train);
proposal = proposal(1:num_train);
tk_seq = [10,20,40,60,80,90,100,120];
img_fold = './JPEGImages/';
% for hog
cellSize = 8;
wid = 50;
hig = 60;
for i = 1 : length(cur_id)
    i
    file_name = cur_id{i};
    save_file = [savefold '/chi2_' phase '_' method '_' file_name '.mat'];
%     if exist(save_file,'file')
        hog_file = [hogfold 'HOG_' file_name '.mat'];
        
        box_file = [mat_fold file_name(1:4) '/' file_name '.mat'];
        box_mat = load(box_file);
        cur_box = box_mat.boxes(1:min(size(box_mat.boxes,1), num_box),:);
        if exist(hog_file,'file')
            load(hog_file);
            if exist('hogr','var')
                hogImg = hogr;
                clear hogr;
            end
        else
            img_file = [img_fold file_name '.jpg'];
            imgf = imread(img_file);
            [hog_time hogImg] = box_to_hog(imgf, cur_box, cellSize, wid, hig);
        end
        pos_ind_img = cell(length(tk_seq),1);
        pos_ind_lab = cell(length(tk_seq),1);
        neg_ind_img = cell(length(tk_seq),1);
        %  get the index in each image for pos and neg
        % compute the IoU between gt box and method box
        gt_box = proposal{i,1}.boxes;
        gt_box_lab = proposal{i,1}.lab; %column
        %    iou_matr: num_gt * num_box
        [iou_matr] = iou_candidates_gt(gt_box(:, [2 1 4 3]), cur_box);
        for n_tk = 1:length(tk_seq)
            tk = min(tk_seq(n_tk),size(iou_matr,2));
            for j = 1:size(gt_box,1)
                [~,ind]=sort(iou_matr(j,:),'descend');
                if j == 1
                    pos_ind = ind(1:tk);
                    pos_lab = gt_box_lab(j)*ones(length(pos_ind),1);
                else
                    pos_ind = [pos_ind ind(1:tk)];
                    pos_lab = [pos_lab; gt_box_lab(j)*ones(length(pos_ind),1)];
                end
            end
            %             pos_ind = unique(pos_ind);
            neg_ind = setdiff(1:size(cur_box,1), unique(pos_ind));
            pos_ind_img{n_tk} = pos_ind;
            pos_ind_lab{n_tk} = pos_lab;
            neg_ind_img{n_tk} = neg_ind;
        end
        tic;
        chi_fea = vl_homkermap(hogImg,.6);
        chi_time = toc;
        clear hogImg;
        save(save_file,...
            'iou_matr','pos_ind_lab','tk_seq','chi_fea','chi_time',...
            'pos_ind_img','neg_ind_img','-v7.3');
%     end
end
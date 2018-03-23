% load train data with CWS feature
% pay great attention to the location of box
% function  = rcnn_feature_cws(method)
clear;
addpath('../Tool/');
% addpath('../Tool_prepare/');
method = 'ss';%'edge';%
phase = 'train';
%train 500, test 100
save_fold  = ['F:/Jing/SS/rcnn_chi2_' phase '/'];
if ~exist(save_fold,'dir')
    mkdir(save_fold)
end
rcnn_fold = 'F:/Jing/Tool/rcnn-master/rcnn-master/';
mat_file = [rcnn_fold 'data/selective_search_data/voc_2007_train.mat'];
rcnfea_fold = [rcnn_fold 'feat_cache/v1_finetune_voc_2007_trainval_iter_70k/voc_2007_' phase '/'];
% rcnfea_fold = [rcnn_fold 'feat_cache/v1_finetune_voc_2007_trainval_iter_70k/' method '70/voc_2007_train/'];
% load train val test index imgName, proposal
% proposal:.boxes [y1 x1 y2 x2] imgName 000005
load('./GtVOC07trainval.mat');
% tk = 10; % TOP k
rcnfea_files = dir([rcnfea_fold '*.mat']);

% num_box = 1200; train
num_box = 2000; %val
num_train = 400;
tk_seq = [10,20,40,60,80,90,100,120];%500,1000];
cur_tk = 1;
for i = 1:num_train%:-1:101% length(rcnfea_files)
    i
    file_name = rcnfea_files(i).name(1:6);
    save_file=[save_fold 'chi2_' method '_' phase '_' file_name '.mat'];
    if ~exist(save_file, 'file')
        pos_ind_img = cell(length(tk_seq), 1);
        neg_ind_img = cell(length(tk_seq), 1);
        %     load image file
        load(mat_file);
        cur_box = boxes{i}(1:min(size(boxes{i},1), num_box),:);
        Indexf = strfind(imgName, file_name);
        Index = find(not(cellfun('isempty', Indexf)));
        %  get the index in each image for pos and neg
        % compute the IoU between gt box and method box
        gt_box = proposal{Index,1}.boxes;
        %    iou_matr: num_gt * num_box
%          ****pay great attention to the [x y] of box
        [iou_matr] = iou_candidates_gt(gt_box(:, [2 1 4 3]), cur_box(:,[2 1 4 3]));
        
        for n_tk = 1:length(tk_seq)
            tk = min(tk_seq(n_tk), size(iou_matr,2));
            for j = 1:size(gt_box,1)
                [~,ind] = sort(iou_matr(j,:),'descend');
                if j == 1
                    pos_ind = ind(1:tk);
                else
                    pos_ind = [pos_ind ind(1:tk)];
                end
            end
            pos_ind = unique(pos_ind);
            neg_ind = setdiff(1:size(iou_matr,2), pos_ind);
            pos_ind_img{n_tk} = pos_ind;
            neg_ind_img{n_tk} = neg_ind;
        end
        load([rcnfea_fold rcnfea_files(i).name]);
        rdfeat = double(feat);
        clear feat;
        tic;
        chi_fea = vl_homkermap(rdfeat,.6);
        chi_time = toc;
%         iou_train_matr = iou_matr;
        save(save_file,...
            'iou_matr','tk_seq','chi_fea','chi_time','pos_ind_img','neg_ind_img','-v7.3');
    end    
end
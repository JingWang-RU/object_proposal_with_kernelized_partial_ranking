% load train data with CWS feature
% function = cws_train_test_top_k(save_fold, mat_file,savefile)
% addpath('../Tool_recall/');
% addpath('../Tool_prepare/');
clear;
addpath('../liblinear-1.91/matlab/');
method = 'ss';%'edge';%
save_fold = ['F:/Jing/SS/'];
%train 500, test 100
% mat_fold = ['E:/Jing/pascal_voc07_candidates_recall/precomputed/' method '_boxes_70/mat/'];
rcnn_fold = 'F:/Jing/Tool/rcnn-master/rcnn-master/';
% mat_file = [rcnn_fold 'data/EB_data/voc_2007_train.mat'];
mat_file = [rcnn_fold 'data/selective_search_data/voc_2007_train.mat'];
rcnfea_fold = [rcnn_fold 'feat_cache/v1_finetune_voc_2007_trainval_iter_70k/voc_2007_train/'];
rcnfea_test_fold = [rcnn_fold 'feat_cache/v1_finetune_voc_2007_trainval_iter_70k/voc_2007_test/'];

% rcnfea_fold = [rcnn_fold 'feat_cache/v1_finetune_voc_2007_trainval_iter_70k/' method '70/voc_2007_train/'];

% img_fold = ['../Images/VOC07/trainval/JPEGImages/'];
% load train val test index imgName, proposal
% proposal:.boxes [y1 x1 y2 x2] imgName 000005
load('./GtVOC07trainval.mat');
train_fold = [save_fold 'rcnn_chi2_train/'];
cur_id = dir([train_fold '*.mat']);%imgName(1:1000);
% proposal = proposal(1:1000);
num_box = 2000;
num_train = 400;
num_test = 4952;

top_k = [10,20,40,60,80,100,300,500,700,900,1000];

tk_seq = [10,20,40,60,80,90,100,120];%[10,20,40,60,80,90,100,120];%200,500,1000];%200,500];%,1000];
s=1;
for cur_tk = 5:5%length(tk_seq)%:-1:3
    ioufold = ['F:/Jing/SS/rcnn_chi2_box_iou_test_' num2str(tk_seq(cur_tk)) '/'];
    if ~exist(ioufold,'dir')
        mkdir(ioufold);
    end
    ind_fold  = ['F:/Jing/' method '/rcnn_chi2_ind_s_' num2str(s) ...
        '_' num2str(tk_seq(cur_tk)) '/'];
    if ~exist(ind_fold, 'dir')
        mkdir(ind_fold);
    end
    tic;
    s=1;    
    model_file = [save_fold 'rcnn_chi2_model/' method '_s_' num2str(s) '_' ...
        num2str(tk_seq(cur_tk)) '_numtrain_' num2str(num_train) '.mat'];
    if ~exist(model_file,'file')
        for i = 1 : num_train
            i
            file_name = cur_id(i).name(15:20);
            fea_file=[train_fold 'chi2_' method '_train_' file_name '.mat'];
            
            load(fea_file);
            if i == 1
                train_pos_chi = chi_fea(pos_ind_img{cur_tk},:);
                train_neg_chi = chi_fea(neg_ind_img{cur_tk},:);
            else
                train_pos_chi = [train_pos_chi; chi_fea(pos_ind_img{cur_tk},:)];
                train_neg_chi = [train_neg_chi; chi_fea(neg_ind_img{cur_tk},:)];
            end
        end
        % train
        C = [0.01,0.1,1]; %[0.001 0.08 0.1 0.6 0.7 1.5 2 20 50 100 1000];%;%
        Ytrain = [ones(size(train_pos_chi,1),1); -1*ones(size(train_neg_chi,1),1)];
        Xtrain = [train_pos_chi; train_neg_chi];
        clear train_pos_chi train_neg_chi chi_fea;
        [model, train_time] = sup_train_model(s,sparse(Xtrain), Ytrain,C);
        fprintf(1,'model train done\n');
        save(model_file,'model','train_time','C','-v7.3');
    else
        load(model_file);
    end
    test_fold = [save_fold 'rcnn_chi2_test/'];
    testfiles = dir([test_fold '*.mat']);
    num_test = length(testfiles);
    test_time = cell(num_test,1);
    rcnn_test_fold = [rcnn_fold 'feat_cache/v1_finetune_voc_2007_trainval_iter_70k/voc_2007_test/'];
    for i = 1 : num_test %length(impos)
        i
        file_test = testfiles(i).name(14:19);
        iou_file = [ioufold file_test '_iou_gt.mat'];
%         if ~exist(iou_file,'file')
            load([test_fold  testfiles(i).name]);
            iou_mat = iou_matr;
            Ytest = ones(size(chi_fea, 1), 1);
            tmp_data = load([rcnfea_test_fold file_test 'mat']);
            cur_box = tmp_data.boxes;
            clear tmp_data;
            tic;
            [~,~,prob] = predict(Ytest, sparse(chi_fea), model{3});
            test_time = toc;
            clear chi_fea;
            [~, ind] = sort(prob,'descend');
            save([ind_fold file_test '.mat'],'ind','prob','cur_box','test_time','-v7.3');
            
%             [test_time{i}, iou_thre, tmp_num_iou, tmp_best_iou, tmp_org_num_iou,tmp_gt] = ...
%                 sup_test_model(model,chi_fea, iou_mat,top_k,C);
%             save(iou_file, 'tmp_best_iou','tmp_num_iou','tmp_org_num_iou',...
%                 'tmp_gt','iou_mat','-v7.3');
%         end        
%         tim = toc
    end
end

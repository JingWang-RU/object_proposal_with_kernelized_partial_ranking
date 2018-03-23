% load train data with CWS feature
clear;
addpath('../liblinear-1.91/matlab/');
method = 'SS';%'MCG';%'m_rs';%'EB';%'OBJ';%'edge';%MCG
mod = 'SS';
tic;
%train 500, test 100
mat_fold = './voc_2007_test.mat';%['F:/Jing/' method '/mat/'];
% load train val test index imgName, proposal
% proposal:.boxes [y1 x1 y2 x2] imgName 000005
% load('../Images/VOC2007/GtVOC07trainval.mat');
num_train = 400; %1000;
iou_thresholds = .5:.1:1;
num_classes = 20;
train_fold = ['F:/Jing/' method '/hog_chi2_train/'];
trainfiles = dir([train_fold '*.mat']);
% test fold of cws feature from hog
feafold = ['F:/Jing/' method '/hog_chi2_test/'];

% testfiles = dir([cwsfold '*.mat']);
load('./pascal_voc07_test_annotations.mat');
num_test = length(impos);

% proposal = proposal(1:1000);
% num_box = 2000;
C = [0.01 0.1 0 1];
tk_seq = [10,20,40,60,80,100,120];
top_k = [10,20,40,60,80,90,100,120,300,316,500,700,900,1000];

mod_fold  = ['F:/Jing/' method '/hog_chi2_model/'];
if ~exist(mod_fold, 'dir')
    mkdir(mod_fold);
end


s = 0;

for cur_tk = 5:5 %1:length(tk_seq)
    ioufold = ['F:/Jing/' method '/hog_chi2_box_iou_test_' num2str(tk_seq(cur_tk)) '/'];
    if ~exist(ioufold,'dir')
        mkdir(ioufold);
    end
    ind_fold  = ['F:/Jing/' method '/hog_chi2_ind_s' num2str(s) ...
        '_' num2str(tk_seq(cur_tk)) '/'];
    if ~exist(ind_fold, 'dir')
        mkdir(ind_fold);
    end
    model_file = [mod_fold mod '_mod_s_' num2str(s) '_' num2str(tk_seq(cur_tk)) '_numtrain_' ...
        num2str(num_train)  '.mat'];
    if ~exist(model_file, 'file')
        for i = 1:num_train
            i
            save_file=[train_fold trainfiles(i).name];%[train_fold file_name '.mat'];
            if ~exist(save_file,'file')
                fprintf(1,'file %s does not exist \n', trainfiles(i).name);
            else
                %fprintf(1,'load train data \n');
                load(save_file);
                if i == 1
                    train_pos_chi = chi_fea(pos_ind_img{cur_tk},:);
                    train_neg_chi = chi_fea(neg_ind_img{cur_tk},:);
                else
                    train_pos_chi = [train_pos_chi; chi_fea(pos_ind_img{cur_tk},:)];
                    train_neg_chi = [train_neg_chi; chi_fea(neg_ind_img{cur_tk},:)];
                end
            end
        end
        % train
        Ytrain = [ones(size(train_pos_chi,1),1); -1*ones(size(train_neg_chi,1),1)];
        Xtrain = [train_pos_chi; train_neg_chi];
        
        clear train_pos_chi train_neg_chi chi_fea;
        [model, train_time] = sup_train_model(s,sparse(Xtrain), Ytrain,C);
        fprintf(1,'train model done\n');
        save(model_file,'model','train_time','C','tk_seq','cur_tk','-v7.3');
    else
        load(model_file);
    end
    % % load test data
    box_mat = load(mat_fold);
    test_time = cell(num_test,1);
    a=0;
    best_iou = cell(length(top_k),1);
    for i = 1:length(impos)
        i
        file_test = impos(i).im; %impos(1,i).im;% SS box mat is from rcnn
        
        load([feafold 'chi2_test_SS_' file_test '.mat']); %cws_test_fea
        iou_file = [ioufold file_test '_iou_gt.mat'];
        if ~exist(iou_file,'file')
            IndexC = strfind(box_mat.images, file_test);
            Index = find(not(cellfun('isempty', IndexC)));
            gt_box = impos(1,Index).boxes;
            
            box_file = ['F:/Jing/' method '/mat/' file_test(1:4) '/' file_test '.mat'];
            matfold = load(box_file);
            cur_box = matfold.boxes;
            iou_mat = iou_candidates_gt(gt_box, cur_box);           
            
            Ytest = ones(size(I_test, 1), 1);
            tic;
            [~,~,prob] = predict(Ytest, sparse(I_test), model{4});
            test_time = toc;
            [~, ind] = sort(prob,'descend');
            save([ind_fold file_test '.mat'],'ind','prob','cur_box','test_time','-v7.3');
%             [test_time{i}, iou_thre, tmp_num_iou, tmp_best_iou, tmp_org_num_iou,tmp_gt] = ...
%                 sup_test_model(model,I_test, iou_mat,top_k,C);
%             save(iou_file, 'gt_box','tmp_best_iou','tmp_num_iou','tmp_org_num_iou',...
%                 'tmp_gt','iou_mat','-v7.3');            
        end
    end
end


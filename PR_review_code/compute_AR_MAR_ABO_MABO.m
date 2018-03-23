% load train data with CWS feature
clear;
addpath('../Tool/');
addpath('../Tool/liblinear-1.91/matlab/');
method = 'SS';%'EB';%'m_rs';%'EB';%'OBJ';%'edge';
mod = 'SS';
tic;
ioufold = ['F:/Jing/' method '/box_iou_test/'];
if ~exist(ioufold,'dir')
    mkdir(ioufold);
end
ioufiles = dir([ioufold '*.mat']);
tk_seq = [10,20,40,60,80,90,100,120];%,500,1000];
top_k = [10,20,40,60,80,90,100,120,300,500,700,900,1000];
iou_thresholds = .5:.1:1;
num_classes = 20;
testset = load('../Images/VOC2007/pascal_voc07_test_annotations.mat');

for cur_tk = 5:5 %length(tk_seq):-1:1
    s = 6;
    result_file = [ioufold method '_mod_' mod '_s_' num2str(s) '_' num2str(tk_seq(cur_tk)) '_numtrain_' ...
        num2str(num_train) '_numtest_' num2str(num_test) '.mat'];
    if ~exist(result_file,'file')
        % % load test data
        test_time = cell(num_test,1);
        best_iou = cell(length(top_k),1);
        for i = 1 : num_test %length(impos)            
            iou_file = [ioufold ioufiles(i).name];
            % the box result of our method
            load(iou_file); %'gt_box','tmp_best_iou','best_box_ind','tmp_num_iou','tmp_org_num_iou',...
            %                 'tmp_gt','iou_mat','-v7.3');
            if i == 1
                num_iou_mod = tmp_num_iou;
                org_num_iou = tmp_org_num_iou;
                num_gt_box = tmp_gt;
                best_iou = tmp_best_iou;
            else
                num_iou_mod = num_iou_mod + tmp_num_iou;
                org_num_iou = org_num_iou + tmp_org_num_iou;
                num_gt_box = num_gt_box + tmp_gt;
                for tk_ind = 1:length(top_k)
                    best_iou{tk_ind} = [best_iou{tk_ind} tmp_best_iou{tk_ind}];
                end
            end
        end
        
%         [overlaps, recall, ARs(i)] = compute_average_recall(best_iou{});
        [overlaps, recall, ARs(i)] = compute_average_recall(best_iou);
        
        for j = 1:numel(iou_thresholds)
            [~,min_idx] = min(abs(overlaps - iou_thresholds(j)));
            recalls(i,j) = recall(min_idx);
        end
        
        for c = 1:num_classes
            masks = get_class_masks(testset.per_class{c}.impos, testset.impos);
%             iou = filter_best_ious(best_iou{}, masks);
            iou = filter_best_ious(best_iou, masks);
            [~, ~, ARs_per_class(i,c)] = compute_average_recall(iou);
        end
        %% compute the ABO and MABO
%         for cI = 1:length(gtBoxes)
%             for i = 1:size(gtBoxes{cI}, 1)
%                 % groundtruth box in images of the same class
%                 there is one gt box for each class of one image
%                 boScores{cI}(classIdx(cI)) = ...
%                     BoxBestOverlap(gtBoxes{cI}(i,:), testBoxes{gtNrs{cI}(i)});
%                 classIdx(cI) = classIdx(cI) + 1;
%             end
%         end        
%         %Calculation abo and mabo measures
%         abo = zeros(nClasses, 1);
%         for cI = 1:nClasses
%             abo(cI) = mean(boScores{cI});
%         end
%         mabo = mean(abo);
        
%         save(result_file,'model','s','AR','ARs_per_class','org_AR',...
%             'recall_mod','num_iou_mod','org_num_iou','ARs_per_class','best_iou','num_gt_box','iou_thre','org_recall','test_time','train_time','dx','top_k',...
%             'tk_seq','cur_tk','C','-v7.3');        
    end
end
toc

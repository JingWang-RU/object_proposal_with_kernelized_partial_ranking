
% evaluation ABO,MABO,AR,RECALL
methods = {'m_rs','EB','OBJ','SS','BING'};
for m = 1:length(methods)
    % method.name = 'SS';
    method.name=[];
    method.name = methods{m};
    % method.sourc_fold = 'F:/Jing/SS/hog_chi2_ind_s0_80/';
    method.sourc_fold = ['F:/Jing/' method.name '/hog_cws_ind_s_6_120/'];
    % method.best_voc07_candidates_file = [method.sourc_fold 'SS_best_candidates.mat'];
    method.best_voc07_candidates_file = ...
        [method.sourc_fold method.name '_best_candidates.mat'];
    num_box = 5000;
    n_methods = 1;
    num_classes = 20;
    iou_thresholds = .5:.025:1;
    
    testset = load('./pascal_voc07_test_annotations.mat');
    
    %generate the best_iou
    compute_best_candidates(testset, method);
end


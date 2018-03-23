
% evaluation ABO,MABO
methods = {'m_rs','EB','OBJ','SS','BING'};


method.name = 'SS';
method.sourc_fold = 'F:/Jing/SS/hog_chi2_ind_s0_80/';
method.best_voc07_candidates_file = [method.sourc_fold 'SS_best_candidates.mat'];

method.ar_file = [method.sourc_fold 'SS_AR_RECALL.mat'];

candidates_thresholds = [10,20,40,60,80,90,100,120,300,316,500,700,900,1000];
% ABO of each class

%% AR RECALL
iou_files{1} = method.best_voc07_candidates_file;
n_methods = 1;
num_classes = 20;
iou_thresholds = .5:.025:1;

testset = load('./pascal_voc07_test_annotations.mat');
results = [];
for k = 1:length(candidates_thresholds)
    k
    num_candidates = candidates_thresholds(k);
    for i = 1:n_methods
        tic;
        data = load(iou_files{i});
        thresh_idx = find( ...
            [data.best_candidates.candidates_threshold] <= num_candidates, 1, 'last');
        experiment = data.best_candidates(thresh_idx);
        [overlaps, recall, ARs] = compute_average_recall(experiment.best_candidates.iou);
        % Average Best Overlap (ABO)
        abo = mean(experiment.best_candidates.iou);
        
        for j = 1:numel(iou_thresholds)
            [~,min_idx] = min(abs(overlaps - iou_thresholds(j)));
            recalls(i,j) = recall(min_idx);
        end
        
        for c = 1:num_classes
            masks = get_class_masks(testset.per_class{c}.impos, testset.impos);
            iou = filter_best_ious(experiment.best_candidates.iou, masks);
            [~, ~, ARs_per_class(i,c)] = compute_average_recall(iou);
        end
        toc;
    end
    resutls(k).num_candidates = num_candidates;
    resutls(k).overlaps = overlaps;
    results(k).abo = abo;
    results(k).recalls = recalls;
    results(k).recall = recall;
    results(k).ARs = ARs;
    results(k).ARs_per_class = ARs_per_class;
    
end
save(method.ar_file, 'results');
fprintf('done, all is well\n');



function compute_best_candidates(testset, methods)
num_annotations = numel(testset.pos);
candidates_thresholds = [10,20,40,60,80,90,100,120,300,316,500,700,900,1000];
%   [1,3,10,32,100,300,316,500,1000,2000,3000,3162,5000,10000];
num_candidates_thresholds = numel(candidates_thresholds);

for method_idx = 1:numel(methods)
    method = methods(method_idx);
    sourc_fold = method.sourc_fold;
    sourc_files = dir([sourc_fold '*.mat']);
    
    try
        load(method.best_voc07_candidates_file, 'best_candidates');
        continue
    catch
    end
    
    % preallocate
    best_candidates = [];
    best_candidates(num_candidates_thresholds).candidates_threshold = [];
    best_candidates(num_candidates_thresholds).best_candidates = [];
    for i = 1:num_candidates_thresholds
        best_candidates(i).candidates_threshold = candidates_thresholds(i);
        best_candidates(i).best_candidates.candidates = zeros(num_annotations, 4);
        best_candidates(i).best_candidates.iou = zeros(num_annotations, 1);
        best_candidates(i).image_statistics(numel(testset.impos)).num_candidates = 0;
    end
    
    pos_range_start = 1;
    for j = 1:numel(testset.impos)
        tic_toc_print('evalutating %s: %d/%d\n', method.name, j, numel(testset.impos));
        pos_range_end = pos_range_start + size(testset.impos(j).boxes, 1) - 1;
        assert(pos_range_end <= num_annotations);
        
        tic_toc_print('sampling candidates for image %d/%d\n', j, numel(testset.impos));
        [~, img_id, ~] = fileparts(testset.impos(j).im);
        candidates=[];
        for i = 1:num_candidates_thresholds
            %         [candidates, scores] = get_candidates(method, img_id, ...
            %           candidates_thresholds(i));
            load([sourc_fold img_id '.mat']);
            box = cur_box(1:min(size(cur_box, 1), 5000),:);
            num = min(size(box,1),candidates_thresholds(i));
            candidates = box(ind(1:num),:);
            if isempty(candidates)
                impos_best_ious = zeros(size(testset.impos(j).boxes, 1), 1);
                impos_best_boxes = zeros(size(testset.impos(j).boxes, 1), 4);
            else
                [impos_best_ious, impos_best_boxes] = closest_candidates(...
                    testset.impos(j).boxes, candidates);
            end
            best_candidates(i).best_candidates.candidates(pos_range_start:pos_range_end,:) = impos_best_boxes;
            best_candidates(i).best_candidates.iou(pos_range_start:pos_range_end) = impos_best_ious;
            best_candidates(i).image_statistics(j).num_candidates = size(candidates, 1);
        end
        
        pos_range_start = pos_range_end + 1;
    end
    
    save(method.best_voc07_candidates_file, 'best_candidates');
end
end
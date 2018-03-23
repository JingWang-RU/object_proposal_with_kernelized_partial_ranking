function masks = get_class_masks(class_gt, gt)
gt_ids = {gt.im};
n = numel(gt_ids);
masks = cell(n,1);

for i = 1:n
    masks{i} = false(size(gt(i).boxes, 1), 1);
end

for i = 1:numel(class_gt), im_id = class_gt(i).im;
    gt_idx = find(strcmp(gt_ids, im_id));
    assert(numel(gt_idx)==1);
    gt_boxes = gt(gt_idx).boxes;
    
    boxes = class_gt(i).boxes;
    % sanity check
    found = ismember(boxes, gt_boxes, 'rows');
    assert(all(found));
    
    masks{gt_idx} = ismember(gt_boxes, boxes, 'rows');
end
end
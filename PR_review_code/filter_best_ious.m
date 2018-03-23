function iou = filter_best_ious(iou, masks)
	flat_mask = cat(1, masks{:});
    assert(numel(iou) == numel(flat_mask));
    iou = iou(flat_mask);
end
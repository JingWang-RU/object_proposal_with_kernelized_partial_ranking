function [iou_matr] = iou_candidates_gt(gt_boxes, candidates)
% iou_matrix = 
% do a matching between gt_boxes and candidates

  gt_boxes = double(gt_boxes);
  candidates = double(candidates);
  
  num_gt_boxes = size(gt_boxes, 1);
  num_candidates = size(candidates, 1);
  
  iou_matrix = zeros(num_gt_boxes, num_candidates);
  for i = 1:num_gt_boxes
    iou = overlap(gt_boxes(i,:), candidates);
    iou_matrix(i,:) = iou';
  end
  iou_matr = iou_matrix;
%   best_overlap = zeros(num_gt_boxes, 1);
%   best_boxes = -ones(num_gt_boxes, 4);
% 
%   [best_overlap,best_boxes] = greedy_matching(iou_matrix, gt_boxes, candidates);
end
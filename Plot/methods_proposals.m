close all;
load('./org_result_figures.mat');
% methods recall_100 recall_500 recall_1000 recall_2000 recall_x iou_x iou_05 iou_07 iou_08 ar;
load('./pr_results_figure.mat');
%methods pr_x pr_100 pr_500 pr_1000 pr_iou_05 pr_iou_07 pr_iou_08 pr_iou_x pr_ar;

xval = pr_x;
data_mat = [recall_500;pr_500];

methods={'BING','CPMC','EB','Endres','GOP','MCG','M-MCG','OBJ','Rantalankila','Rigor','RP','RS','SS',...
    'PR-EB','PR-GOP','PR-MCG','PR-OBJ','PR-Rigor','PR-RS','PR-SS'};
for i = 1:20
   if i < 14
      lineshape{i} = '--'; 
   else
      lineshape{i} = '-';
   end  
end

ind_method = [1:20];
% xval = pr_x;
xlab = 'IoU overlap threshold';
% xlab = '# proposals';
ylab = 'Recall';
% ylab = 'Average recall';
colr_ind = [4,10,6,11,2,8,9,7,12,13,3,5,1,6,2,8,7,13,5,1]; %numel(methods);%2*ones(1,length(methods));
ymin = 0;%0.5;
ymax = 1;%0.9;
linew = 2.5;
% location ='SouthEast';
% location ='NorthWest';
 location ='NorthEast';
xfsize = 20;
yfsize = 20;
lfont = 6;
figh = plot_base(xval, data_mat, methods, ind_method, xlab, ylab, ymin, ymax,...
    xfsize, yfsize, linew, lineshape, colr_ind, location, lfont);
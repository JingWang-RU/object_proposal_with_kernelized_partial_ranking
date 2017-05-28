clear;
close all;
% load('./eb_mcg_obj_rs_ss_K_r300_06');
load('./eb_mcg_obj_rs_ss_K_r100_ar500');
% xval = [0.5 : 0.1 : 1.0];
xval = [10,20,40,60,80,100,120];
% xval = [10,20,40,60,80,90,100,120,300,500,700,900,1000];
% data_mat = recall;
data_mat = ar;
methods ={'EB', 'MCG','OBJ','RS', 'SS'};
ind_method = [1:length(methods)];
% xlab = 'IoU overlap threshold';
% xlab = '# proposals';
xlab = 'Top k';
% ylab = 'Recall';
ylab = 'Average recall';
% pr_set = [2,4,6,8,9];

% lineshape = {'-','-','-', '-','-','-',':'};
    lineshape = {'-o','-o','-o', '-o','-o','-',':'};
% colr_ind = [1:7]; %numel(methods);
colr_ind = [6,8,7,5,1];
ymin = 0.3;%0.5;
ymax = 0.9;%0.9;
linew = 2.5;
% location ='NorthEast';
location ='SouthEast';
%  location ='SouthWest';
set(gca,'xtick',xval);
xlim([10,120]);
xfsize = 20;
yfsize = 20;%15
lfont = 15;
figh = plot_base(xval, data_mat, methods, ind_method, xlab, ylab, ymin, ymax,...
    xfsize, yfsize, linew, lineshape, colr_ind, location, lfont);
clear;
close all;
% load('./hog_chi_cws_recall_ar');
% load('./hog_rcnn_cws_recall_ar');
% load('./hog_rcnn_linear_recall_ar');
% svmrank
% load('./pr_svmrank_500.mat');
% load('./pr_svmrank_05.mat');
% load('.//pr_svmrank_08.mat');
% load('./pr_svmrank_ar.mat');
% load('./ss_k_100');
% load('./ss_k_05');
load('./ss_k_ar');
ind = [1,3,5,7];
% ind=4;% 1 0.5; 2 0.6; 3 0.7; 4 0.8
% xval = [0.5 : 0.1 : 1.0];
% xval = [10,20,40,60,80,100,300,500,700,900,1000];
xval = [10,20,40,60,80,90,100,120,300,500,700,900,1000];
% data_mat = recall;%(ind,:);
% data_mat = recall(ind,:);
% data_mat = [hog_linear_ar';rcnn_linear_ar'; hog_chi_ar';rcnn_chi_ar';...
%     hog_cws_ar';rcnn_cws_ar'];
% ind=8;%500
% ind=7;%300
% ind=6;%100
% data_mat = [hog_linear_recall(:,ind)';rcnn_linear_recall(:,ind)'; ...
%     hog_chi_recall(:,ind)';rcnn_chi_recall(:,ind)';hog_cws_recall(:,ind)';...
%     rcnn_cws_recall(:,ind)'];
% data_mat = [hog_linear_recall(ind,:);rcnn_linear_recall(ind,:); ...
%     hog_chi_recall(ind,:);rcnn_chi_recall(ind,:);hog_cws_recall(ind,:);...
%     rcnn_cws_recall(ind,:)];
% data_mat = ar;
data_mat=ar(ind,:);
ind_method = 1:size(data_mat,1);
methods={'k=10','k=40','k=80','k=120'};
% methods = methods(ind,:);
% methods = {'SVM^{\fontsize{10}{RANK}}','PR'};
% methods = {'Linear-HOG','Linear-RCNN','\chi-HOG','\chi-RCNN',...
%     'Minmax-HOG', 'Minmax-RCNN'};
% xlab = 'IoU overlap threshold';
xlab = '# proposals';
% ylab = 'Recall';
ylab = 'Average recall';
% pr_set = [2,4,6,8,9];

% lineshape = {'--','-','--','-', '--', '-'};
% colr_ind = [8,8,5,5,1,1]; %numel(methods);%2*ones(1,length(methods));

% lineshape = {'-','-','--','-', '-', '-','-'};
% colr_ind = [8,1];

lineshape={'-','-', '-','-'};
colr_ind = [1,8,5,6];
ymin = 0;%0.5;
ymax = 1.0;%0.9;
linew = 2.5;
% location ='NorthEast';%
location ='SouthEast';
%  location ='SouthWest';
xfsize = 20;
yfsize = 20;%15
lfont = 15;
set(gca,'xtick',[0.5:0.1:1.0]);
xlim([0.5,1.0]);
% set(gca,'xtick',[0:200:1000]);
% set(gca,'ytick',[0.4:0.1:1.0]);

% In ../Tool/plot_base.m
figh = plot_base(xval, data_mat, methods, ind_method, xlab, ylab, ymin, ymax,...
    xfsize, yfsize, linew, lineshape, colr_ind, location, lfont);
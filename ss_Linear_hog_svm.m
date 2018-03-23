% function tim = Linear_hog_svm()
% linear SVM
% addpath ('./codes/liblinear-1.91/matlab');
clear;
% addpath ('./Tool/liblinear-1.91/matlab');
addpath ('../../research/liblinear-1.91/matlab');

% train SVM
method = 'SS';%'BING';%'EB';
testfold = ['./' method '/hog/'];
tesdir = dir( [ testfold 'HOG_00*.mat' ] );
num_test = length(tesdir);

svmfold = ['./' method '/linear_hog_svm/'];
if ~exist(svmfold,'dir')
    mkdir(svmfold);
end
modelfold = './Tool/linear_model/';
C = [0.001 0.005 0.01 0.02 0.05 0.08 0.1 0.2 0.3 10 100 1000];%0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2  1.5 2 4 6  8 10 15 20 50 100 500 1000];
num_C = length(C);

for j = 1:num_test
    file = tesdir(j).name;
    savefile = [svmfold 'linear_' file(5:end)];
    if ~exist(savefile,'file')
        load([testfold file]);%hogImg
        if exist('hogImg')
            I_test = hogImg;
            clear hogImg;
        else
            I_test = hogr;
            clear hogr;
        end
        Y_test = ones(size(I_test,1),1);
        
        img_prob = cell(num_C,1);
        %         img_label = cell(num_C,1);
        %         img_accu = cell(num_C,1);
        tic;
        for i = 1:num_C
            c = C(i);
            %     load model
            load([modelfold 'linear_model_c_' num2str(c) '.mat']);%,'model','tim','-v7.3');
            
            [label,accur,prob] = predict(Y_test,sparse(I_test),model);
            img_prob{i,1} = prob;
            %             img_label{i,1} = label;
            %             img_accu{i,1} = accur;
            clear model;
        end
        tim = toc;
        %         save(savefile, 'img_prob','img_label','img_accu','C','-v7.3');
        save(savefile, 'img_prob','C','tim','-v7.3');
    end
end

% function tim = CWS_SVM()
% linear SVM
% addpath ('./codes/liblinear-1.91/matlab');
clear;
addpath ('../../research/liblinear-1.91/matlab');
% train SVM
method = 'MCG';%'SS';% 'BING';
testfold = ['./' method '/cws/'];
tesdir = dir( [ testfold 'CWS_*.mat' ] );
num_test = length(tesdir);

svmfold = ['./' method '/cwssvm/'];
if ~exist(svmfold,'dir')
    mkdir(svmfold);
end
modelfold = './Tool/cws_model/';
C = [0.001 0.005 0.01 0.02 0.05 0.08 0.1 0.2 0.3 10 100 1000];%0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2  1.5 2 4 6  8 10 15 20 50 100 500 1000];
num_C = length(C);
% indSun = [4501:4881,4883:4952];
for j = 1:num_test
    
    file = tesdir(j).name;
    savefile = [svmfold 'svm_' file(5:end)];
    if ~exist(savefile,'file')
        load([testfold file]);%I_test,Y_test
        img_prob = cell(num_C,1);
%         img_label = cell(num_C,1);
%         img_accu = cell(num_C,1);
tic;
        for i = 1:num_C
            c = C(i);
            %     load model
            load([modelfold 'CWS_model_c_' num2str(c) '.mat']);%,'model','tim','-v7.3');
            
            [label,accur,prob] = predict(Y_test,I_test,model);
            img_prob{i,1} = prob;
%             img_label{i,1} = label;
%             img_accu{i,1} = accur;
            clear model;
        end
        tim = toc;
%         save(savefile, 'img_prob','img_label','img_accu','C','-v7.3');
         save(savefile, 'img_prob','tim','C','-v7.3');
    end
end

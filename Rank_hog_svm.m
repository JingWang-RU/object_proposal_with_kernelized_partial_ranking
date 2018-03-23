function tim = Rank_hog_svm()
% linear SVM
clear;
Meth = {'EB','SS'};
for m = 1:length(Meth)
    method = Meth{m};% 'BING';%;
    testfold = ['./' method '/hog/'];
    tesdir = dir( [ testfold 'HOG_00*.mat' ] );
    num_test = length(tesdir);
    
    svmfold = ['./' method '/rank_hog_svm/'];
    if ~exist(svmfold,'dir')
        mkdir(svmfold);
    end
    modelfile = './Tool/rankhogmodel/hog_VOC07rank.mat';
    load(modelfile);%,'w','bias'
    for j = 1:num_test
        file = tesdir(j).name;
        savefile = [svmfold method '_rank_hog_' file(5:end)];
        if ~exist(savefile, 'file')
            load([testfold file]);%hogImg
            if exist('hogImg')
                I_test = hogImg;
                clear hogImg;
            else
                I_test = hogr;
                clear hogr;
            end
            img_prob = zeros(size(I_test,1),1);
            tic;
            img_prob = I_test*w;
            tim = toc;
            %         save(savefile, 'img_prob','img_label','img_accu','C','-v7.3');
            save(savefile, 'img_prob','tim','-v7.3');
        end
    end
end
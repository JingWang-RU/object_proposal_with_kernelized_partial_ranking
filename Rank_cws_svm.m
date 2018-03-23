function tim = Rank_cws_svm()
% linear SVM
clear;
Meth = {'BING','EB','SS','MCG'};
for m = 1:length(Meth)
    method = Meth{m};%;
    testfold = ['./' method '/cws/'];
    tesdir = dir( [ testfold 'CWS_00*.mat' ] );
    num_test = length(tesdir);
    
    svmfold = ['./' method '/rank_cws_svm/'];
    if ~exist(svmfold,'dir')
        mkdir(svmfold);
    end
    modelfile = './Tool/rankcwsmodel/cws_VOC07rank.mat';
    load(modelfile);%,'w','bias'
    for j = 1 : num_test
        file = tesdir(j).name;
        savefile = [svmfold method '_rank_cws_' file(5:end)];
        if ~exist(savefile, 'file')
            load([testfold file]);%I_test            
            img_prob = zeros(size(I_test,1),1);
            tic;
            img_prob = I_test*w;
            tim = toc;
            %         save(savefile, 'img_prob','img_label','img_accu','C','-v7.3');
            save(savefile, 'img_prob','tim','-v7.3');
        end
    end 
end

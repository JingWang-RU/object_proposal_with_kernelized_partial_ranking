% load train data with CWS feature
clear;
addpath('../liblinear-1.91/matlab/');
methods = {'m_rs','EB','OBJ','SS','BING'};
for m = 1:length(methods)
    method = methods{m};%'m_rs';%'EB';%'OBJ';%'SS';%'edge';%MCG
    mod = 'SS';
    tic;
    %train 500, test 100
    
    num_train = 400; %1000;
    train_fold = ['F:/Jing/' method '/hog_cws_train/'];
    trainfiles = dir([train_fold '*.mat']);
    C = [0.0001 0.0005 0.0008 0.001 0.002 0.01 0.1];
    
    top_k = [10,20,40,60,80,100,300,500,700,900,1000];
    tk_seq = [10,20,40,60,80,90,100,120];
    mod_fold  = ['F:/Jing/' mod '/hog_cws_model/'];
    num_test=4952;
    s = 6;
    for cur_tk = 8:8 %1:length(tk_seq)
        ind_fold  = ['F:/Jing/' method '/hog_cws_ind_s_' num2str(s) ...
            '_' num2str(tk_seq(cur_tk)) '/'];
        if ~exist(ind_fold, 'dir')
            mkdir(ind_fold);
        end
        model_file = [mod_fold mod '_mod_s_' num2str(s) '_' num2str(tk_seq(cur_tk)) '_numtrain_' ...
            num2str(num_train)  '.mat'];
        load(model_file);
        
        % % load test data
        test_fold = ['F:/Jing/' method '/hog_cws_test/'];
        testfiles = dir([test_fold '*.mat']);
        
        test_time = cell(num_test,1);
        for i = 1 : num_test %length(impos)
            i
            filename = testfiles(i).name;
            load([test_fold filename]);
            tmp_data = load(['F:/Jing/' method '/mat/' filename(5:8) '/' filename(5:end)]);
            cur_box = tmp_data.boxes;
            clear tmp_data;
            Y_test = ones(size(I_test,1),1);
            tic;;
            [~,~,prob] = predict(Y_test, sparse(I_test), model{length(model)});
            test_time = toc;
            clear I_test;
            [~, ind] = sort(prob,'descend');
            save([ind_fold filename(5:10) '.mat'],'ind','prob','cur_box','test_time','-v7.3');
        end
    end
end
toc

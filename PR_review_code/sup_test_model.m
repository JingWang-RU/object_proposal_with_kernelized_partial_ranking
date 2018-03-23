function  [test_time, iou_thre, num_iou_model, best_iou, org_num_iou, num_gt_img] = ...
    sup_test_model(model, KernelTest, iou_matrix,tk_seq,C)

% C=[0.001 0.005 0.01 0.02 0.05 0.08 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2  1.5 2 4 6  8 10 15 20 50 100 500 1000];
% C = [0.001 0.08 0.1 0.6 0.7 1.5 2 20 50 100 1000];
iou_thre = 0.5:0.1:1.0;
% tk_seq = [10,20,40,60,80,100,300,500,700,900,1000];
num_iou_model = zeros(length(tk_seq),length(iou_thre));
iou_mat = iou_matrix'; %now num_box*num_gt
num_gt_img = size(iou_mat,2);
org_num_iou = zeros( length(tk_seq), length(iou_thre));
best_iou = cell(length(tk_seq),1);
% best_box_ind = cell(length(tk_seq),1);
% fin_iou = zeros(1,size(iou_mat,2));
for t = 1:length(C);
    num_iou = zeros( length(tk_seq),length(iou_thre));
    tic;
    Ytest = ones(size(KernelTest, 1), 1);
    [~,~,prob] = predict(Ytest, KernelTest, model{t});
    %     rank svm
    %     prob = KernelTest*model{t};
    test_time = toc;
    [~, ind] = sort(prob,'descend');
    for k = 1 : length(tk_seq)     
        fin_iou = max(iou_mat(ind(1:min(tk_seq(k),length(ind))),:));

        if  t == 1
            org_iou = max(iou_mat(1:min(tk_seq(k),length(ind)),:));
            best_iou{k}=fin_iou;
%             best_box_ind{k} = ind(1:min(tk_seq(k),length(ind)));
        else
            best_iou{k} = max(fin_iou, best_iou{k});
%             if max(max(iou_mat(ind(1:min(tk_seq(k),length(ind))),:)))>max(fin_iou)
%                best_box_ind{k} = ind(1:min(tk_seq(k),length(ind)));
%             end
%             fin_iou = max(iou_mat(ind(1:min(tk_seq(k),length(ind))),:));
        end
        for th = 1 : length(iou_thre)
            num_iou(k,th) = length(find(fin_iou >= iou_thre(th)));
            if t == 1
                org_num_iou(k,th) = length(find(org_iou >= iou_thre(th)));
            end
        end
         
    end
    num_iou_model = max(num_iou_model, num_iou);
end

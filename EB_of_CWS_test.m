% load('./Images/VOC07/VOC07train.mat');
clear;
% % matlabpool;
load('./VOC07_CWS_RCB.mat');
% 
% % RK = cell(K,1);
% % CK = cell(K,1);
% % BK = cell(K,1);
% % ntest = 5000;
% % tic;
% % for k = 1:K
% %     RK{k} = ones(ntest, 1) * R(:, k)';
% %     CK{k} = ones(ntest, 1) * C(:, k)';
% %     BK{k} = ones(ntest, 1) * Beta(:, k)';
% % end
% % tt = toc
% % clear R C Beta;
% %,'R','C','Beta','RK','BK','CK','-v7.3');
% % save('./Data_kernel/VOC07_CWS_RCB_K.mat','RK','BK','CK','-v7.3');
method = 'EB';%'MCG';%;%'SS';
hogfold = ['./' method '/'];
load('./VOC07test_ims.mat');
% % num_test = length(test_files);
num_test = length(testIms);
K = 1024;
b = 8;
% 
cwsfold = ['./' method '/cws/'];
if ~exist(cwsfold,'dir')
   mkdir(cwsfold); 
end
for i = 3001:4500%:4952%1495:2092%num_test
    %     if mod(i,100)==0
    %         disp(i);
    %     end
    tesfile = ['HOG_' testIms{i,1} '.mat'];
    savefile = [cwsfold 'CWS_' tesfile(5:end)];
    if ~exist(savefile,'file')
        i
        load([hogfold tesfile]);
        u = hogImg;%hogr;
        clear hogImg;
% u = hogr;
% clear hogr;
        ntest = size(u,1);
        %inc = 0:2^b:(ntest-1)*2^b;
        %         if size(u,1) < 5000
        %             disp('test proposals less than 5000');
        %         end
        %I_test = sparse(zeros(ntest, 2^b * K));
        Y_test = ones(ntest,1);
        tic;
        logU = log(u);
        tmps = cell(1, K);
        parfor k = 1:K
            %             r = matrixMultiply(ones(ntest, 1), R(:, k)');
            %             c = matrixMultiply(ones(ntest, 1), C(:, k)');
            %             beta = matrixMultiply(ones(ntest, 1), Beta(:, k)');
            r = R(:,k)';
            c = C(:,k)';
            beta = Beta(:,k)';
            
            %             t = floor(logU ./ r + beta);
            t = floor(bsxfun(@plus,bsxfun(@rdivide,logU,r) , beta));
            %             y = exp((t-beta) .* r);
            y = exp(bsxfun(@times,bsxfun(@minus,t,beta),r));
            %             a = c ./ (y .* exp(r));
%             a = bsxfun(@rdivide,c,bsxfun(@times,y,exp(r)));
            a = bsxfun(@rdivide,c,exp(bsxfun(@plus,bsxfun(@times,bsxfun(@minus,t,beta),r),r)));

            [~, istar] = min(a, [], 2);
            
            istar = mod(istar-1, 2^b)+1;
            %istar = istar' + inc;
            ridx = 1:ntest;
            val = ones(ntest, 1);
            tmps{k} = sparse(ridx, istar, val, ntest, 2^b, ntest);
            
            %istar to a binary vector
            %tmp = zeros(2^b, ntest);
            % tmp(istar) = 1;
            %I_test(:, (k-1)*(2^b)+1:k*(2^b)) = sparse(tmp');
            % clear r c beta t y a istar tmp;
        end
        I_test = cell2mat(tmps);
        tim = toc
        save(savefile, 'I_test', 'Y_test', 'tim','-v7.3');
    end
end
% I_train = sparse(I_train);
% I_test = sparse(I_test);
% save('./Data_kernel/VOC07_CWS_train_.mat', 'I_train', 'Y_train', 'R','C','Beta','-v7.3');
% save(['./Data_kernel/VOC07_CWS_RCb_' num2str(D) '.mat'], 'I_train', 'I_test', 'Y_train', 'Y_test', 'R','C','Beta','-v7.3');

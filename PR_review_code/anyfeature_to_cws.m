function [cws_time cws_fea] = anyfeature_to_cws(anyfea,K,D,b)
% generate the CWS feature
% anyfea:num_box*feature
% K = 128;
% b = 4;
rcb_file = ['./cws_K_' num2str(K) '_D_' num2str(D) '.mat'] ;
if ~exist(rcb_file,'file')
    R = gamrnd(2,1,[K D]);
    C = gamrnd(2,1,[K D]);
    Beta = unifrnd(0,1,[K D]);
    save(rcb_file,'R','C','Beta','-v7.3');
else
    load(rcb_file);
end

u = anyfea;
num_ins = size(u,1);
tic;
logU = log(u);
tmps = cell(1, K);
for k = 1:K
    r = R(k,:);
    c = C(k,:);
    beta = Beta(k,:);
    t = floor(bsxfun(@plus,bsxfun(@rdivide,logU,r) , beta));
    a = bsxfun(@rdivide,c,exp(bsxfun(@plus,bsxfun(@times,bsxfun(@minus,t,beta),r),r)));
    [~, istar] = min(a, [], 2);
    istar = mod(istar-1, 2^b)+1;
    %istar = istar' + inc;
    ridx = 1:num_ins;
    val = ones(num_ins, 1);
    tmps{k} = sparse(ridx, istar, val, num_ins, 2^b, num_ins);
end
cws_fea = cell2mat(tmps);
cws_time = toc;
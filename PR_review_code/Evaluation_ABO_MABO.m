
% evaluation ABO,MABO
addpath('./Dependencies/');
method.name = 'SS';
method.sourc_fold = 'F:/Jing/SS/hog_chi2_ind_s0_80/';
method.abo_file = [method.sourc_fold 'SS_ABO_MABO_candidates.mat'];
sourc_files = dir([method.sourc_fold '*.mat']);

candidates_thresholds = [10,20,40,60,80,90,100,120,300,316,500,700,900,1000];
%% ABO MAO
load('GroundTruthVOC2007test.mat'); %gtBoxes,gtImIds
result = [];
for i = 1:1%length(candidates_thresholds)
    i
    testBoxes = [];
    for j = 1:length(sourc_files)
        load([method.sourc_fold sourc_files(i).name]);
        box = cur_box(1:min(size(cur_box, 1), 5000),:);
        num = min(size(box,1),candidates_thresholds(i));
        candidates = box(ind(1:num),:);
        %gtBoxes in GroundTruthVOC2007 is in the order of y1 x1 y2 x2
        testBoxes{j} = candidates(:,[2 1 4 3]);
    end
    
%     [boxAbo boxMabo boScores avgNumBoxes] = ...
%         BoxAverageBestOverlap(gtBoxes, gtImIds, testBoxes);
    [boxAbo boxMabo boScores avgNumBoxes] = ...
        BoxAverageBestOverlap(gtBoxes, gtImIds, testBoxes);
    result(i).candidates_threshold = candidates_thresholds(i);
    result(i).boxAbo = boxAbo;
    result(i).boxMabo = boxMabo;
    result(i).boScores = boScores;
    result(i).avgNumBoxes = avgNumBoxes;
end
% save(method.abo_file,'result');


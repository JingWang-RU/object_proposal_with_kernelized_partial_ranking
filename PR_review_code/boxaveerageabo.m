function [abo mabo boScores avgNumBoxes] = boxaveerageabo(per_class, gtNrs, testBoxes)
% [abo mabo boScores avgNumBoxes] = BoxAverageBestOverlap(gtBoxes, gtNrs, testBoxes)
%
% Calculate Average Best Overlap scores
%
% gtBoxes:      Cell array of ground truth boxes per class (see
%               GetAllObjectBoxes)
% gtNrs:        Cell array with image nrs corresponding to ground truth.
% testBoxes:    Cell array of testboxes per image.
%
% abo:          Average Best Overlap per class (Pascal Overlap criterion)
% mabo:         Mean Average Best Overlap (mean(abo))
% boScores:     Best Overlap Score per GT box.
% avgNumBoxes:  Average number of boxes per image
%
%     Jasper Uijlings - 2013

% Check nr of gt elements
nClasses = length(per_class);

boScores = cell(1, nClasses);
for cI = 1:nClasses
    boScores{cI} = zeros(size(per_class{cI}.impos, 1),1);
end

% indices per class
classIdx = ones(1, nClasses);

for cI = 1:length(per_class)
    for i = 1:size(per_class{cI}.impos, 1)
        boScores{cI}(classIdx(cI)) = ...
                    BoxBestOverlap(per_class{cI}(i,:), testBoxes{gtNrs{cI}(i)});
%         tmp = gtBoxes{cI}(i,:);
%         boScores{cI}(classIdx(cI)) = ...
%             closest_candidates(tmp(:,[2 1 4 3]), testBoxes{gtNrs{cI}(i)});
        classIdx(cI) = classIdx(cI) + 1;        
    end
end

% Calculation abo and mabo measures
abo = zeros(nClasses, 1);
for cI = 1:nClasses
    abo(cI) = mean(boScores{cI});
end
mabo = mean(abo);

% Calculation avgNumBoxes
numBoxes = zeros(length(testBoxes), 1);
for i=1:length(testBoxes)
    numBoxes(i) = size(testBoxes{i}, 1);
end
avgNumBoxes = mean(numBoxes);
% save the training box to regioni image
% Then extrat the HOG feature of the region images
function [hog_time hogImg] = box_to_hog(imgf, box,cellSize, wid,hig)
% imgf: imread(image file)
% img_id: name of image
% addpath('../Tool_prepare/');
% cellSize = 8;
% wid = 50;
% hig = 60;
tic;
wid_max = box(:,3) - box(:,1);
hei_max = box(:,4) - box(:,2);
box_img_max = [box(:,1) box(:,2) wid_max hei_max];
hogImg = zeros(size(box,1),1488);%1488 is the dim of hog given cell size, wid, hig
for j = 1:size(box,1)
    box_img = box_img_max(j,:);
    region = imcrop(imgf,box_img);
    ihog = img_hog(region, wid, hig, cellSize);
    hogImg(j,:) = ihog;
end
hog_time = toc;

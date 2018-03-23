function hog = img_hog(img, wid, hig, cellSize)
% img:image
% wid, high: size after reshape
% addpath('./codes/vlfeat/toolbox/');
imr = imresize(img, [wid hig]);
im = im2single(imr) ;

org_hog = vl_hog(im, cellSize) ;
[a b c] = size(org_hog);
hog = reshape(org_hog, [1, a*b*c]);

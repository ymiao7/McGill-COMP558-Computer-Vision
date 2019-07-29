function pyramid = construct_pyramid(im)

% In this method, we input an image and create a 3-level pyramid for the
% image. We store the image pyramid in a cell and return it as output of
% this function.

pyramid = {};

% Construct Gaussian Pyramid
% Level 1
filt0 = fspecial('gaussian',[3 3],1);
im_1 = conv2(im,filt0,'same');
pyramid{1} = im_1;

% Level 2
filt1 = fspecial('gaussian',[3 3],2);
im_2 = conv2(im_1,filt1,'same');
im_2 = imresize(im_2,0.5);
pyramid{2} = im_2;

% Level 3
filt2 = fspecial('gaussian',[3 3],4);
im_3 = conv2(im_2,filt2,'same');
im_3 = imresize(im_3,0.5);
pyramid{3} = im_3;

end
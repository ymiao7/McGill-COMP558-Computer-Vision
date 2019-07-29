%-------------------------- Main function---------------------------------%
close all
clear variables
clc

%============================== Q1 test ==================================%
image = imread('q1_test.jpg');
image_to_grayscale = rgb2gray(image);
filter = make2DGaussian(19,5);
im_out = myConv2(image_to_grayscale, filter);
im_out = mat2gray(im_out);

gaussFilt = fspecial('gaussian',19,5);
im_conv = conv2(image_to_grayscale,gaussFilt,'same');
im_conv = mat2gray(im_conv);

figure
subplot 231, imshow(image_to_grayscale,[]); title('Grayscale Image')
subplot 232, surf(filter); title('my Gaussian Filter')
subplot 233, imshow(im_out,[]); title('myGaussian Filtered Image')

subplot 234, imshow(image_to_grayscale,[]); title('Grayscale Image')
subplot 235, surf(gaussFilt); title('Gaussian Filter by fspecial')
subplot 236, imshow(im_conv,[]); title('conv Gaussian Filtered Image')

% %============================== Q2 test ==================================%
image_q2 = imread('q2_test.jpg');

% Resize the image so that it can be displayed in full resolution
image_q2 = imresize(image_q2,0.28);

% Try different values of sigma
sigma_q2 = 0.4;
%sigma_q2 = 0.8;
%sigma_q2 = 1.6;
threshold = 0.02;
im_out_q2 = edge_detect_with_gradient(image_q2,sigma_q2,threshold);
% figure, imshow(im_out_q2);title('image output of q2');
%============================== Q3 code ==================================%

% First create a image with size 400x400
image_q3 = zeros(400,400);
[image_x,image_y] = size(image_q3);

% Now we draw 3 rectangles inside the image
x_min1 = 20;
x_max1 = 300;
y_min1 = 30;
y_max1 = 180;

x_min2 = 80;
x_max2 = 390;
y_min2 = 150;
y_max2 = 390;

x_min3 = 80;
x_max3 = 220;
y_min3 = 20;
y_max3 = 190;

% Assign different grayscale values to different rectangles
image_q3(x_min1:x_max1,y_min1:y_max1,:) = 50;
image_q3(x_min2:x_max2,y_min2:y_max2,:) = 175;
image_q3(x_min3:x_max3,y_min3:y_max3,:) = 230;

[im_rows,im_cols] = meshgrid(1:image_x, 1:image_y);

% Next create 2 circles in the image.
x_center1 = 100;
x_center2 = 300;
y_center1 = 200;
y_center2 = 300;

radius1 = 50
radius2 = 100

circle1 = (im_cols - y_center1).^2 + (im_rows - x_center1).^2 <= radius1.^2;
circle2 = (im_cols - y_center2).^2 + (im_rows - x_center2).^2 <= radius2.^2;

% Combine the rectangles and circles into one image
image_q3 = imfuse(image_q3,circle1);
image_q3 = imfuse(image_q3,circle2);
image_q3 = rgb2gray(image_q3);
figure,imshow(image_q3,[]);

filt_size = [9 9];

% Try different values of sigma
sigma_q3 = 0.53;
%sigma_q3 = 1.65;
%sigma_q3 = 1.9;

threshold1 = 0.003;
im_out_q3 = edge_detect_with_MH(image_q3, filt_size, sigma_q3, threshold1);

%============================== Q4 code ==================================%
% figure, imshow(image_q2);
image_q2_crop = image_q2(720:739,810:829);
figure,subplot 221 ,imshow(image_q2_crop); title('original q2 crop image')
im_out_q2_crop = im_out_q2(720:739,810:829);
subplot 222, imshow(im_out_q2_crop); title('q2 edge image')

% figure, imshow(image_q3);
image_q3_crop = image_q3(190:209,270:289);
subplot 223 ,imshow(image_q3_crop); title('original q3 crop image')
im_out_q3_crop = im_out_q3(190:209,270:289);
subplot 224, imshow(im_out_q3_crop); title('q3 edge image')

[image_q2_crop_rows, image_q2_crop_cols] = size(image_q2_crop);
[X1,Y1] = meshgrid(1:image_q2_crop_cols,1:image_q2_crop_rows);
Z1 = double(image_q2_crop);
[DX1,DY1] = gradient(Z1);

figure
subplot(2,1,1),imshow(image_q2_crop); title('image q2 crop')
hold on
quiver(X1,Y1,DX1,DY1)
hold off

[image_q3_crop_rows, image_q3_crop_cols] = size(image_q3_crop);
[X2,Y2] = meshgrid(1:image_q3_crop_cols,1:image_q3_crop_rows);
Z2 = double(image_q3_crop);
[DX2,DY2] = gradient(Z2);

subplot(2,1,2),imshow(image_q3_crop); title('image q3 crop')
hold on
quiver(X2,Y2,DX2,DY2)
hold off

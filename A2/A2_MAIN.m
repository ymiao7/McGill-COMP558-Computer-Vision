%-------------------------- Main function---------------------------------%
close all
clear variables
clc

image = imread('james.jpg');
%-------------------------- Q1 test --------------------------------------%
% figure,imshow(image);
heat_equation(image);
%-------------------------- Q2 test --------------------------------------%
pyramids_and_sift(image);
% Crop of image
im_scale = imresize(image(120:240,60:290,:),0.6);
pyramids_and_sift(im_scale);
im_rotate = imrotate(image(120:240,60:290,:),15);
pyramids_and_sift(im_rotate);

%-------------------------- Q3 test --------------------------------------%
% Edge detection;
sigma = 0.02;
input_threshold=0.035;
[row_idx,col_idx,theta] = edge_detect_with_gradient(image,sigma,input_threshold);

RANSAC(row_idx,col_idx,theta);

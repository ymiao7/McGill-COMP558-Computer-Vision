function pyramids_and_sift(image)

im_green = image(:,:,2); % Green channel
im = im2double(im_green);

%---------------------------- Part One -----------------------------------%

% Construct Gaussian Pyramid
% Level 0
filt0 = fspecial('gaussian',[3 3],1)
im_0 = conv2(im_green,filt0,'same');

% Level 1
filt1 = fspecial('gaussian',[3 3],2)
im_1 = conv2(im_0,filt1,'same');
im_1 = imresize(im_1,0.5);

% Level 2
filt2 = fspecial('gaussian',[3 3],4)
im_2 = conv2(im_1,filt2,'same');
im_2 = imresize(im_2,0.5);

% Level 3
filt3 = fspecial('gaussian',[3 3],8)
im_3 = conv2(im_2,filt3,'same');
im_3 = imresize(im_3,0.5);

% Level 4
filt4 = fspecial('gaussian',[3 3],16)
im_4 = conv2(im_3,filt4,'same');
im_4 = imresize(im_4,0.5);

% Level 5
filt5 = fspecial('gaussian',[3 3],32)
im_5 = conv2(im_4,filt5,'same');
im_5 = imresize(im_5,0.5);

% figure,imshow(im_green,[]);title('original image')
% figure,imshow(im_0,[]);title('level 0 Gaussian Pyramid')
% figure,imshow(im_1,[]);title('level 1 Gaussian Pyramid')
% figure,imshow(im_2,[]);title('level 2 Gaussian Pyramid')
% figure,imshow(im_3,[]);title('level 3 Gaussian Pyramid')
% figure,imshow(im_4,[]);title('level 4 Gaussian Pyramid')
% figure,imshow(im_5,[]);title('level 5 Gaussian Pyramid')

%---------------------------- Part Two -----------------------------------%

% Construct Laplacian Pyramid

% Level 5
im_lp_5 = im_5;

% Level 4
im_5 = imresize(im_5,2);
im_5 = conv2(im_5,filt4,'same');
[temp1 temp3]=size(im_5);
[temp2 temp4]=size(im_4);
if temp1~=temp2||temp3~=temp4
    im_4 = padarray(im_4,[abs(temp2-temp1) abs(temp4-temp3)],'replicate','post');
end
im_lp_4 = im_5-im_4;

% Level 3
im_4 = imresize(im_4,2);
im_4 = conv2(im_4,filt3,'same');
[temp1 temp3]=size(im_4);
[temp2 temp4]=size(im_3);
if temp1~=temp2||temp3~=temp4
    im_3 = padarray(im_3,[abs(temp2-temp1) abs(temp4-temp3)],'replicate','post');
end
im_lp_3 = im_4-im_3;

% Level 2
im_3 = imresize(im_3,2);
im_3 = conv2(im_3,filt2,'same');
[temp1 temp3]=size(im_3);
[temp2 temp4]=size(im_2);
if temp1~=temp2||temp3~=temp4
    im_2 = padarray(im_2,[abs(temp2-temp1) abs(temp4-temp3)],'replicate','post');
end
im_lp_2 = im_3-im_2;

% Level 1
im_2 = imresize(im_2,2);
im_2 = conv2(im_2,filt1,'same');
[temp1 temp3]=size(im_2);
[temp2 temp4]=size(im_1);
if temp1~=temp2||temp3~=temp4
    im_1 = padarray(im_1,[abs(temp2-temp1) abs(temp4-temp3)],'replicate','post');
end
im_lp_1 = im_2-im_1;

% Level 0
im_1 = imresize(im_1,2);
im_1 = conv2(im_1,filt0,'same');
[temp1 temp3]=size(im_1);
[temp2 temp4]=size(im_0);
if temp1~=temp2||temp3~=temp4
    im_0 = padarray(im_0,[abs(temp2-temp1) abs(temp4-temp3)],'replicate','post');
end
im_lp_0 = im_1-im_0;

% figure,imshow(im_lp_0,[]);title("level 0 Laplacian Pyramid")
% figure,imshow(im_lp_1,[]);title("level 1 Laplacian Pyramid")
% figure,imshow(im_lp_2,[]);title("level 2 Laplacian Pyramid")
% figure,imshow(im_lp_3,[]);title("level 3 Laplacian Pyramid")
% figure,imshow(im_lp_4,[]);title("level 4 Laplacian Pyramid")
% figure,imshow(im_lp_5,[]);title("level 5 Laplacian Pyramid")

%---------------------------- Part Three ---------------------------------%
% Choose sigma = 1.6 and k = sqrt(2) to approximate a Laplacian of a
% Gaussian with a difference of Gaussians
sigma = 1.6;
k = sqrt(2);
gaussian1 = fspecial('gaussian', 200, k*sigma);
gaussian2 = fspecial('gaussian', 200, sigma);
DoG = gaussian1 - gaussian2;
% Scale DoG by (k-1)*sigma^2 to make a comparison with LoG
DoG = DoG/((k-1)*sigma^2);

% Implement a Laplacian of a Gaussian filter
filt_rows = 200;
filt_cols = 200;
LoG = zeros(filt_rows,filt_cols);

for i=1:filt_rows
    for j=1:filt_cols
        x=(j-ceil(filt_cols/2));
        y=(i-ceil(filt_rows/2));        
        LoG(i,j)=(-1/(pi*sigma*sigma*sigma*sigma))*(1-((x*x+y*y)/(2*sigma*sigma)))*exp((-(x*x+y*y)/sigma*sigma)/(2*sigma*sigma));
    end
end
% figure
% subplot 121,surf(DoG(90:110,90:110));title("DoG")
% subplot 122,surf(LoG(90:110,90:110));title("LoG")

%---------------------------- Part Four ----------------------------------%

% Find extrema of each level %
% Low contrast thresholds (get rid of extrema with intensity less than the
% threshold
thre_1 = 10.0;
thre_2 = 10.0;
thre_3 = 10.0;
thre_4 = 10.0;

% Gradient thresholds (get rid of extrema with intensity differences between
% central pixel and four neighbor pixels that are not ALL greater than the 
% threshold
grad_thre1 = 15.0;
grad_thre2 = 18.0;
grad_thre3 = 20.0;
grad_thre4 = 10.0;
level_1_pts = find_extrema(im_lp_0,im_lp_1,im_lp_2,2,thre_1,grad_thre1);
level_2_pts = find_extrema(im_lp_1,im_lp_2,im_lp_3,4,thre_2,grad_thre2);
level_3_pts = find_extrema(im_lp_2,im_lp_3,im_lp_4,8,thre_3,grad_thre3);
level_4_pts = find_extrema(im_lp_3,im_lp_4,im_lp_5,16,thre_4,grad_thre4);

% Multiplier for index to map the indices of resized images to the original
% image
mult1 = 2;
mult2 = 4;
mult3 = 8;
mult4 = 16;

% Plot the detected keypoints on the image with circles centered at
% keypoints
% The radius of the circles are 1.6 times the corresponding sigma's

figure
imshow(image);
num1 = length(level_1_pts);
num2 = length(level_2_pts);
num3 = length(level_3_pts);
num4 = length(level_4_pts);

hold on
for i=1:num1
    centx = mult1*cell2mat(level_1_pts{i}{1}(1));
    centy = mult1*cell2mat(level_1_pts{i}{1}(2));
    radius = 1.6*cell2mat(level_1_pts{i}{1}(3));

    theta = 0 : (2 * pi / 10000) : (2 * pi);
    pline_x = radius * cos(theta) + centx;
    pline_y = radius * sin(theta) + centy;
    plot(pline_x, pline_y, 'r-', 'LineWidth', 1.3);

end

for i=1:num2
    centx = mult2*cell2mat(level_2_pts{i}{1}(1));
    centy = mult2*cell2mat(level_2_pts{i}{1}(2));
    radius = 1.6*cell2mat(level_2_pts{i}{1}(3));
    %radius = 1;

    theta = 0 : (2 * pi / 10000) : (2 * pi);
    pline_x = radius * cos(theta) + centx;
    pline_y = radius * sin(theta) + centy;
    plot(pline_x, pline_y, 'g-', 'LineWidth', 1.3);

end

for i=1:num3
    centx = mult3*cell2mat(level_3_pts{i}{1}(1));
    centy = mult3*cell2mat(level_3_pts{i}{1}(2));
    radius = 1.6*cell2mat(level_3_pts{i}{1}(3));

    theta = 0 : (2 * pi / 10000) : (2 * pi);
    pline_x = radius * cos(theta) + centx;
    pline_y = radius * sin(theta) + centy;
    plot(pline_x, pline_y, 'y-', 'LineWidth', 1.3);

end

for i=1:num4
    centx = mult4*cell2mat(level_4_pts{i}{1}(1));
    centy = mult4*cell2mat(level_4_pts{i}{1}(2));
    radius = 1.6*cell2mat(level_4_pts{i}{1}(3));

    theta = 0 : (2 * pi / 10000) : (2 * pi);
    pline_x = radius * cos(theta) + centx;
    pline_y = radius * sin(theta) + centy;
    plot(pline_x, pline_y, 'b-', 'LineWidth', 1.3);
end

hold off

end
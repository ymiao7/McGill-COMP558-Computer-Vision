%-------------------------- Heat Equation---------------------------------%
function heat_equation(image)
% Select green channel of the input image

im_green = image(:,:,2); % Green channel
im_green = im2double(im_green);

% imshow(im_green,[0 255]);

% Blur the image to generate a family of smoothed images, with smoothing
% scales sigma = 4,8,12,16
im_gauss4 = imgaussfilt(im_green,4);
im_gauss8 = imgaussfilt(im_green,8);
im_gauss12 = imgaussfilt(im_green,12);
im_gauss16 = imgaussfilt(im_green,16);

%==================== Implement heat equation ============================%

% Calculate the total diffution time corresponding to sigma = 4,8,12,16
total_time4 = 0.5*4^2;
total_time8 = 0.5*8^2;
total_time12 = 0.5*12^2;
total_time16 = 0.5*16^2;

% Set number of iteration 
iter1 = 10;
iter2 = 35;
iter3 = 85;
iter4 = 130;

% Then we can get our delta_t
delta_t_4 = total_time4/iter1;
delta_t_8 = total_time8/iter2;
delta_t_12 = total_time12/iter3;
delta_t_16 = total_time16/iter4;

% Get size of padded image
[rows,cols] = size(im_green);

% Heat equation smoothing with time_step4
im_curr4 = im_green;
for i=0:delta_t_4:iter1
    im_next4 = zeros(rows,cols);

    [gx, gy] = gradient(im_curr4);
    [gxx, gxy] = gradient(gx);
    [gxy, gyy] = gradient(gy);
    
    im_next4 = im_curr4+delta_t_4*(gxx+gyy);    
    %figure,imshow(im_next4);
    im_curr4 = im_next4;
end

im_time_step4 = im_curr4;

% Heat equation smoothing with time_step8
im_curr8 = im_green;
for i=0:delta_t_8:iter2
    im_next8 = zeros(rows,cols);

    [gx, gy] = gradient(im_curr8);
    [gxx, gxy] = gradient(gx);
    [gxy, gyy] = gradient(gy);
    
    im_next8 = im_curr8+delta_t_8*(gxx+gyy);    
    %figure,imshow(im_next8);
    im_curr8 = im_next8;
end

im_time_step8 = im_curr8;

% Heat equation smoothing with time_step12
im_curr12 = im_green;
for i=0:delta_t_12:iter3
    im_next12 = zeros(rows,cols);

    [gx, gy] = gradient(im_curr12);
    [gxx, gxy] = gradient(gx);
    [gxy, gyy] = gradient(gy);
    
    im_next12 = im_curr12+delta_t_12*(gxx+gyy);    
    %figure,imshow(im_next4);
    im_curr12 = im_next12;
end

im_time_step12 = im_curr12;

% Heat equation smoothing with time_step16
im_curr16 = im_green;
for i=0:delta_t_16:iter4
    im_next16 = zeros(rows,cols);

    [gx, gy] = gradient(im_curr16);
    [gxx, gxy] = gradient(gx);
    [gxy, gyy] = gradient(gy);
    
    im_next16 = im_curr16+delta_t_16*(gxx+gyy);    
    im_curr16 = im_next16;
end

im_time_step16 = im_curr16;

figure
subplot 341, imshow(im_gauss4); title('Gaussian sigma=4')
subplot 342, imshow(im_gauss8); title('Gaussian sigma=8')
subplot 343, imshow(im_gauss12); title('Gaussian sigma=12')
subplot 344, imshow(im_gauss16); title('Gaussian sigma=16')


subplot 345, imshow(im_time_step4); title('Heat Equation1,iter=10')
subplot 346, imshow(im_time_step8); title('Heat Equation2,iter=35')
subplot 347, imshow(im_time_step12); title('Heat Equation,iter=85')
subplot 348, imshow(im_time_step16); title('Heat Equation4,iter=130')

subplot 349, imshow(abs(im_time_step4-im_gauss4)); title('difference 1')
subplot(3,4,10), imshow(abs(im_time_step8-im_gauss8)); title('difference 2')
subplot(3,4,11), imshow(abs(im_time_step12-im_gauss12)); title('difference 3')
subplot(3,4,12), imshow(abs(im_time_step16-im_gauss16)); title('difference 4')
end
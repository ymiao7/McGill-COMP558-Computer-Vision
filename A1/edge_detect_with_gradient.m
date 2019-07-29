function im_out = edge_detect_with_gradient(image,sigma,input_threshold)

% figure, imshow(image); title('original image')

% Convert image to double precision
image = im2double(image); 

% Decompose the image into RGB
im_red = image(:,:,1); % Red channel
im_green = image(:,:,2); % Green channel
im_blue = image(:,:,3); % Blue channel
% figure, imshow(im_green); title('green channel image')


% Take the green channel, make it into gray scale JPG image
%which -all builtin;
imwrite(im_green, 'q2_green_channel_image.jpg','jpg');

% Filter the image with a Gaussian to decrease noise
gaussFilt = fspecial('gaussian',3,sigma);
% im_filtered = imfilter(im_green, gaussFilt, 'symmetric', 'same'); 
im_filtered = conv2(im_green,gaussFilt,'same');
% figure, imshow(im_filtered); title('im filtered')


% Pad image
im_filtered_padded = padarray(im_filtered, [1, 1], 0.0, 'both');

% Take local difference in the x direction
[im_rows, im_columns] = size(im_filtered);
im_x_diff = zeros(im_rows,im_columns);

for i=1:im_rows
    for j=1:im_columns
        im_x_diff(i,j) = (1/2)*im_filtered_padded(i+1,j+2)-(1/2)*im_filtered_padded(i+1,j);
    end
end

% Take local difference in the y direction
im_y_diff = zeros(im_rows,im_columns);

for i=1:im_rows
    for j=1:im_columns
        im_y_diff(i,j) = (1/2)*im_filtered_padded(i+2,j+1)-(1/2)*im_filtered_padded(i,j+1);
    end
end

figure
subplot 121,imshow(im_x_diff,[]); title('x direction')
subplot 122,imshow(im_y_diff,[]); title('y direction')

% Compute the gradient magnitude at each pixel
im_grad_magnitude = zeros(im_rows, im_columns);
im_grad_magnitude = sqrt(im_x_diff.^2 + im_y_diff.^2).*0.5;

% Compute the gradient orientation at each pixel
im_grad_orientation = zeros(im_rows, im_columns);
for i=1:im_rows
    for j=1:im_columns
        im_grad_orientation(i,j) = atan(im_y_diff(i,j)/im_x_diff(i,j));
    end
end

%=========================== Q5 code start ===============================%

% Plot frequency distribution for image gradient in both x and y direction
figure,
subplot(3,2,1),hist(im_x_diff(:), 255);title('image x without normalization')
subplot(3,2,2),hist(im_y_diff(:), 255);title('image y without normalization')

% Normalize the frequency distributions by dividing by the number of pixels
% and then take log of them
N1 = hist(im_x_diff(:), 255);
N_norm1 = N1./numel(im_x_diff);
N2 = hist(im_y_diff(:), 255);
N_norm2 = N2./numel(im_y_diff);

subplot(3,2,3),bar(N_norm1);title('image x normalized')
subplot(3,2,5),bar(log(N_norm1));title('image x normalized with log')
subplot(3,2,4),bar(N_norm2);title('image y normalized')
subplot(3,2,6),bar(log(N_norm2));title('image y normalized with log')

%============================ Q5 code end ================================%

% Create a binary image which indicates the edge positions
im_binary = zeros(im_rows, im_columns);
threshold = input_threshold;

for i=1:im_rows
    for j=1:im_columns
        if im_grad_magnitude(i,j)>=threshold
            im_binary(i,j)=1;
        end
    end
end

figure, imshow(im_binary); title('binary image that shows edge')

% Assign the binary image as output image
im_out = im_binary;

end
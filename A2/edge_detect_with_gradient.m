function [row_idx,col_idx,theta] = edge_detect_with_gradient(image,sigma,input_threshold)

% Work with only green channel
im_green = image(:,:,2); % Green channel
im = im2double(im_green);

% Filter the image with a Gaussian to decrease noise
gaussFilt = fspecial('gaussian',3,sigma);
% im_filtered = imfilter(im_green, gaussFilt, 'symmetric', 'same'); 
im_filtered = conv2(im,gaussFilt,'same');
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

% figure
% subplot 121,imshow(im_x_diff,[]); title('x direction')
% subplot 122,imshow(im_y_diff,[]); title('y direction')

% Compute the gradient magnitude at each pixel
im_grad_magnitude = zeros(im_rows, im_columns);
im_grad_magnitude = sqrt(im_x_diff.^2 + im_y_diff.^2).*0.5;

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
imshow(im_binary);
% Find the indices of edge pixels
[row_idx,col_idx] = find(im_binary==1.0);
[num_pts,temp] = size(row_idx);

% Compute the gradient orientation at the edge pixels
theta = [];

for i=1:num_pts
    y = row_idx(i);
    x = col_idx(i);
    theta(i) = atan(im_y_diff(y,x)/im_x_diff(y,x));
end

% Transform row vector into column vector
theta = theta';
end
function im = myConv2(image, filter)

% Convert image to double precision (to perform convolution with the
% filter)
image = im2double(image);

% Padding the image
[image_rows, image_columns] = size(image);
[filter_rows, filter_columns] = size(filter);
padded_image = padarray(image, [floor(filter_rows/2), floor(filter_columns/2)], 0.0, 'both');
[im_temp_rows, im_temp_columns] = size(padded_image);

% Initialize output image
im_temp = zeros(im_temp_rows, im_temp_columns);

% Convolution  
for j=ceil(filter_rows/2):ceil(filter_rows/2)+image_rows-1
    for k=ceil(filter_columns/2):ceil(filter_columns/2)+image_columns-1
        A=filter(:,:).*padded_image(j-floor(filter_rows/2):j+floor(filter_rows/2),k-floor(filter_columns/2):k+floor(filter_columns/2));
        im_temp(j,k) = sum(sum(A));    
    end        
end    
    
% Output final image
im_temp = 255 * mat2gray(im_temp);
im = im_temp(ceil(filter_rows/2):ceil(filter_rows/2)+image_rows-1,ceil(filter_columns/2):ceil(filter_columns/2)+image_columns-1);
end
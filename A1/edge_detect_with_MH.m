function im_out = edge_detect_with_MH(image, filt_size, sigma,threshold)

% Convert image to double precision (to perform convolution with the
% filter)
image = im2double(image);

% Since this image is created in matlab manually, we don't need to use a
% Gaussian filter to reduce its noise.

% Implement a Laplacian of a Gaussian filter
% gaussFilt = fspecial('gaussian',filt_size,sigma);
filt_rows = filt_size(1);
filt_cols = filt_size(2);
LoG = zeros(filt_rows,filt_cols);

for i=1:filt_rows
    for j=1:filt_cols
        x=(j-ceil(filt_cols/2));
        y=(i-ceil(filt_rows/2));        
        LoG(i,j)=(-1/(pi*sigma*sigma*sigma*sigma))*(1-((x*x+y*y)/(2*sigma*sigma)))*exp((-(x*x+y*y)/sigma*sigma)/(2*sigma*sigma));
    end
end
%figure,surf(LoG);

% Convolve LoG with image
im_conv = conv2(image,LoG,'same');
figure, imshow(im_conv+0.7);    % +0.7 here is to distinguish shapes of different grayscales
[im_conv_rows, im_conv_cols] = size(im_conv);

% Find zero-crossings and create a binary image that indicates where these
% zero-crossing points are
im_binary = zeros(im_conv_rows, im_conv_cols);

for i=2:im_conv_rows-1
    for j=2:im_conv_cols-1
        if (im_conv(i-1,j)*im_conv(i+1,j)<0)||(im_conv(i,j-1)*im_conv(i,j+1)<0)||(im_conv(i-1,j-1)*im_conv(i+1,j+1)<0)||(im_conv(i+1,j-1)*im_conv(i-1,j+1)<0)
            if abs(im_conv(i-1,j)-im_conv(i+1,j))>=threshold||abs(im_conv(i,j-1)-im_conv(i,j+1))>=threshold||abs(im_conv(i-1,j-1)-im_conv(i+1,j+1))>=threshold||abs(im_conv(i+1,j-1)*im_conv(i-1,j+1))>=threshold
                im_binary(i,j)=1;
            end
        end
    end
end
figure,imshow(im_binary);
im_out = im_binary;

end


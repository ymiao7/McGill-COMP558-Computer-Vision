
function g = make2DGaussian(N,sigma)

% Initialize the filter with a NxN zero matrix
filter = zeros(N,N);

% Initialize the sum of the elements in the filter for normalization
filter_sum = 0;

% Calculate M 
M = (N-1)/2;

    for i=1:N
        for j=1:N
            % Calculate the square distance of one pixel to the origin
            % (M+1,M+1)
            dist_to_center = (i-(M+1))^2+(j-(M+1))^2;

            % Update values in the filter matrix 
            filter(i,j) = exp((-1)*(dist_to_center)/(2*sigma*sigma));

            % Update the sum of elements in the filter
            filter_sum = filter_sum+filter(i,j);

        end
    end

% Return the normalized Gaussian filter    
g = filter/filter_sum;
end



%  Question 2
clc
clear variables

close all
readPositions  %  reads given positions of XYZ and xy1 and xy2 for two images
numPositions = size(XYZ,1);

close all
Iname = 'c1.jpg';
xy = xy1;
 
[P, K, R, C] = calibrate(XYZ, xy);
        
%  Normalize the K so that the coefficients are more meaningful.
K = K/K(3,3);

%------------ Fitting errors (produce similar image shifts) --------------%

% Show changing the K transformation can lead to a similar shift as changing the R
for count = 1:2
    switch count
        case 1
            im_name = 'Transformed K (image shift)';
        case 2
            im_name = 'Transformed R (image shift)';
    end
    %  Display image with keypoints
    
    I = imread(Iname);
    NX = size(I,2);
    NY = size(I,1);
    imageInfo = imfinfo(Iname);
    figure;
    imshow(I);
    title(im_name);
    hold on

    %  Draw in green the keypoints locations that were hand selected.
    for j = 1:numPositions
        plot(xy(j,1),xy(j,2),'g*');
    end
    
    switch count
        case 1
            % Apply a transformation to K
            T_K = [1 0 30; 0 1 0; 0 0 1]; % add noise to T_K to make it nonsingular (i.e. we want inv(T_K) * K * T_R ~= K)
            K1 = T_K*K;
            K1(2,1) = 0; % To guarantee that K is upper triangular
            K1(3,1) = 0;
            K1(3,2) = 0;
            P = K1 * R * [eye(3), -C];

        case 2
             % Apply a transformation to R

            theta = 0.3;
            theta_y1 = theta *pi/180;
            T_R = [cos(theta_y1) 0 sin(theta_y1);  0 1 0;  -sin(theta_y1) 0  cos(theta_y1)];
            R2 = T_R*R;
            P = K * R2 * [eye(3), -C];

            % Check if R2 is orthonormal
            err = 1.0e-10;
            result = norm(inv(R2)-R2','fro');
            disp(result<err);

            P2 = K * R2 * [eye(3), -C];
           
    end
    T_K = T_K;
    
    for j = 1:numPositions
        p = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
        x = p(1)/p(3);
        y = p(2)/p(3);
        %  Draw in white square the projected point positions according to the fit model.
        plot(ceil(x),ceil(y),'ws');
    end
end

% Show changing the K transformation can lead to a similar shift as changing the C
for count = 1:2

    switch count
        case 1
            im_name = 'Transformed K (image shift)';
        case 2
            im_name = 'Transformed C (image shift)';
    end
    %  Display image with keypoints
    
    I = imread(Iname);
    NX = size(I,2);
    NY = size(I,1);
    imageInfo = imfinfo(Iname);
    figure;
    imshow(I);
    title(im_name);
    hold on
    %  Draw in green the keypoints locations that were hand selected.
    for j = 1:numPositions
        plot(xy(j,1),xy(j,2),'g*');
    end
    
    switch count
        case 1
            % Apply a transformation to K
            T_K = [1 0 -30; 0 1 0; 0 0 1];
            K2 = T_K*K;
            K2(2,1) = 0; % To guarantee that K is upper triangular
            K2(3,1) = 0;
            K2(3,2) = 0;
            P = K2 * R * [eye(3), -C];
            
        case 2
            % Apply a transformation to C
            T_C = [1 -0.06 0.05; 0.0038 1 0; 0 0 1];
            C1 = T_C*C;
            P = K * R * [eye(3), -C1];    
    end
    
    T_K = T_K;
    for j = 1:numPositions
        p = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
        x = p(1)/p(3);
        y = p(2)/p(3);
        %  Draw in white square the projected point positions according to the fit model.
        plot(ceil(x),ceil(y),'ws');
    end

end
     
%-------------------------------- End ------------------------------------%


%----------- Fitting errors (produce similar image expansions) -----------%
% Show how changing the K transformation can lead to a similar expansion as
% changing the C
for count = 1:2
    
    switch count
        case 1
            im_name = 'Transformed K (image expansion)';
        case 2
            im_name = 'Transformed C (image expansion)';
    end
    
    %  Display image with keypoints
    
    I = imread(Iname);
    NX = size(I,2);
    NY = size(I,1);
    imageInfo = imfinfo(Iname);
    figure;
    imshow(I);
    title(im_name);
    hold on

    %  Draw in green the keypoints locations that were hand selected.

    for j = 1:numPositions
        plot(xy(j,1),xy(j,2),'g*');
    end
    
    switch count
        case 1            
            % Apply a transformation to K
            T_K = [0.67 0 0; 0 0.67 0; 0 0 1];
            K2 = T_K*K;
            P = K2 * R * [eye(3), -C];
        case 2
            % Apply a transformation to C
            T_C = [1.5 0 0; 0 1.5 0; 0 0 1.5];
            C1 = T_C*C;
            P = K * R * [eye(3), -C1];         
    end
    T_K = T_K;
    for j = 1:numPositions
        p = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
        x = p(1)/p(3);
        y = p(2)/p(3);
        %  Draw in white square the projected point positions according to the fit model.
        plot(ceil(x),ceil(y),'ws');
    end
end
%-------------------------------- End ------------------------------------%
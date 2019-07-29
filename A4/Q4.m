%  Question 4 -  Homographies
close all
clc
clear variables

% Read in the c1.jpg image
I = imread('c1.jpg');

% Get RGB values
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
colorinfo = {R,G,B};

readPositions
numPositions = size(XYZ,1);


%===================Projection Matrix==================%
%------Hard code matrix K------%
% For camera1
f1 = 50; % focal length
Nx = 23.6; % sensor size
Ny = 15.8;
mx = size(I,2)/Nx;
my = size(I,1)/Ny;
px = round(size(I,2)/2);
py = round(size(I,1)/2);

S1 = [mx 0 0; 0 my 0; 0 0 1]; % scale transformation matrix 
T1 = [1 0 px; 0 1 py; 0 0 1]; % translation matrix
F1 = [f1 0 0 0; 0 f1 0 0; 0 0 1 0]; % Projection matrix 
K1 = T1*S1*F1;
K1 = K1(:,1:3);

% For camera2
f2 = 25;
S2 = [mx/2 0 0; 0 my/2 0; 0 0 1]; % scale transformation matrix (half the resolution)
T2 = [1 0 px/2; 0 1 py/2; 0 0 1];% translation matrix
F2 = [f2 0 0 0; 0 f2 0 0; 0 0 1 0]; % Projection matrix 
K2 = T2*S2*F2;
K2 = K2(:,1:3);

%------Rotation matrix R------%
% For camera1
[~, ~, R1, ~] = calibrate(XYZ, xy1);

% For camera2
theta = 20; % Change the rotation angle relative to the first camera
theta_y1 = theta *pi/180;
R2_temp = [cos(theta_y1) 0 sin(theta_y1);  0 1 0;  -sin(theta_y1) 0  cos(theta_y1)];
R2 = R2_temp*R1;
 
%===================Homography==================%
H = K2 * R2 * inv(K1*R1);

% Initialize second camera's image
I2 = zeros(size(I,1)/2,size(I,2)/2,3);

for i = 1:size(I,1)
    for j = 1:size(I,2)
        % Find the mapped coordinates
        coor = [j;i;1];
        V = H * coor;
        V = V/V(3,1);
        x = V(1,1);
        y = V(2,1);

        x = round(x);
        y = round(y);
        if x < 1 || x > size(I2,2) || y < 1 || y > size(I2,1)
            continue;
        else
            I2(y,x,1) = colorinfo{1}(i,j);
            I2(y,x,2) = colorinfo{2}(i,j);
            I2(y,x,3) = colorinfo{3}(i,j);
        end
    end
end
I2 = uint8(I2);
figure;imagesc(I2)

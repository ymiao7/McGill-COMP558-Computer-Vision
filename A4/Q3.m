%  Q3_Tester

clear variables
clc
close all

%  Set up a simple scene and projection scenario

XYZ = [0 0 0; ...
    0 0 1;
    0 1 0;
    0 1 1;
    1 0 0;
    1 0 1;
    1 1 0;
    1 1 1];

K = [300 0 20; 0 300 -30; 0 0 1];
num_degrees = 15;
theta_y = num_degrees *pi/180;
R = [cos(theta_y) 0 sin(theta_y);  0 1 0;  -sin(theta_y) 0  cos(theta_y)];
C = [0.5 0.5 -2]';
P = K * R * [ eye(3), -C];

%--------------------- Shifts using K versus R ---------------------------%
figure; hold on;

numPositions = size(XYZ,1);

%  Draw in black square the projected point positions according to the true model.
for j = 1:numPositions
    p1 = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
    x1 = p1(1)/p1(3);
    y1 = p1(2)/p1(3);
    plot(x1, y1,'sk');
end
for count = 1:2

    switch count
        case 1
            T_K = [1 0 85; 0 1 0; 0 0 1];
            K1 = T_K*K;
            P1 = K1 * R * [ eye(3), -C];

            %  Plot the shifted points in red (projection matrix: P1)
            for j = 1:numPositions
                p2 = P1*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
                x2 = p2(1)/p2(3);
                y2 = p2(2)/p2(3);
                plot(x2,y2,'*r');
            end
        case 2
            theta = 15;
            theta_y1 = theta *pi/180;
            T_R = [cos(theta_y1) 0 sin(theta_y1);  0 1 0;  -sin(theta_y1) 0  cos(theta_y1)];
            R1 = T_R*R;
            P2 = K * R1 * [ eye(3), -C];

            %  Plot the shifted points in blue (projection matrix: P2)
            for j = 1:numPositions
                p2 = P2*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
                x2 = p2(1)/p2(3);
                y2 = p2(2)/p2(3);
                plot(x2,y2,'*b');
            end
    end    
end
hold off

%-------------------------------- End ------------------------------------%

%--------------------- Shifts using K versus C ---------------------------%
figure; hold on;

numPositions = size(XYZ,1);

%  Draw in black square the projected point positions according to the true model.
for j = 1:numPositions
    p1 = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
    x1 = p1(1)/p1(3);
    y1 = p1(2)/p1(3);
    plot(x1, y1,'sk');
end

for count2 = 1:2
    switch count2
    
        case 1
            T_K = [1 0 10; 0 1 0; 0 0 1];
            K1 = T_K*K;
            P1 = K1 * R * [ eye(3), -C];

            %  Plot the shifted points in red (projection matrix: P1)
            for j = 1:numPositions
                p2 = P1*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
                x2 = p2(1)/p2(3);
                y2 = p2(2)/p2(3);
                plot(x2,y2,'*r');
            end
        case 2
            T_C = [1 -0.01 0.028; 0 1 0; 0 0 1];
            C1 = T_C*C;
            P2 = K * R * [ eye(3), -C1];

            %  Plot the shifted points in blue (projection matrix: P2)
            for j = 1:numPositions
                p2 = P2*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
                x2 = p2(1)/p2(3);
                y2 = p2(2)/p2(3);
                plot(x2,y2,'*b');
            end
    end
end
hold off

%-------------------------------- End ------------------------------------%


%------------------- Expansions using K versus C -------------------------%
figure; hold on;

numPositions = size(XYZ,1);

%  Draw in black square the projected point positions according to the true model.
for j = 1:numPositions
    p1 = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
    x1 = p1(1)/p1(3);
    y1 = p1(2)/p1(3);
    plot(x1, y1,'sk');
end
for count3 = 1:2
    switch count3    
        case 1
            T_K = [0.9 0 0; 0 0.9 0; 0 0 1];
            K1 = T_K*K;
            P1 = K1 * R * [ eye(3), -C];

            %  Plot the shifted points in red (projection matrix: P1)
            for j = 1:numPositions
                p2 = P1*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
                x2 = p2(1)/p2(3);
                y2 = p2(2)/p2(3);
                plot(x2,y2,'*r');
            end

        case 2
            T_C = [1 0 0; 0 1 0; 0 0 1.1];
            C1 = T_C*C;
            P2 = K * R * [ eye(3), -C1];

            %  Plot the shifted points in blue (projection matrix: P2)
            for j = 1:numPositions
                p2 = P2*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
                x2 = p2(1)/p2(3);
                y2 = p2(2)/p2(3);
                plot(x2,y2,'*b');
            end
            
    end
end
%-------------------------------- End ------------------------------------%

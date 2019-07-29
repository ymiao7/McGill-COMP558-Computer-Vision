function [Vx,Vy] = compute_LK_optical_flow(frame_1,frame_2,type_LK)

% You have to implement the Lucas Kanade algorithm to compute the
% frame to frame motion field estimates. 
% frame_1 and frame_2 are two gray frames where you are given as inputs to 
% this function and you are required to compute the motion field (Vx,Vy)
% based upon them.
% -----------------------------------------------------------------------%
% YOU MUST SUBMIT ORIGINAL WORK! Any suspected cases of plagiarism or 
% cheating will be reported to the office of the Dean.  
% You CAN NOT use packages that are publicly available on the WEB.
% -----------------------------------------------------------------------%

% There are three variations of LK that you have to implement,
% select the desired alogrithm by passing in the argument as follows:
% "LK_naive", "LK_iterative" or "LK_pyramid"

im1 = im2double(rgb2gray(frame_1));
im2 = im2double(rgb2gray(frame_2));

% Blur the two images
filt_sigma = 0.5;
im1 = imgaussfilt(im1,filt_sigma);
im2 = imgaussfilt(im2,filt_sigma);

% Window sizes for different sequence of images
m_basketball = 31;
m_backyard = 49;

switch type_LK

    case "LK_naive"
        % YOUR IMPLEMENTATION GOES HERE
        % Window size for Basketball
        %m = m_basketball;

        % Window size for Backyard
        m = m_backyard;

        It = im2-im1;
        [Ix, Iy] = gradient(im1);
        W = fspecial('gaussian',[m m],m/3);
        Ixx = conv2(Ix.*Ix,W,'same');
        Iyy = conv2(Iy.*Iy,W,'same');
        Ixy = conv2(Ix.*Iy,W,'same');
        Ixt = conv2(Ix.*It,(1/m^2)*ones(m),'same');
        Iyt = conv2(Iy.*It,(1/m^2)*ones(m),'same');

        m_half = floor(m/2);
        Vx = zeros(size(It));
        Vy = zeros(size(It));
        A = zeros(2);
        B = zeros(2,1);
        %iterate only on the relevant parts of the images
        for i = 1+m_half : size(It,1)-m_half  
            for j = 1+m_half : size(It,2)-m_half
                A(1,1) = Ixx(i,j);
                A(2,2) = Iyy(i,j);
                A(1,2) = Ixy(i,j);
                A(2,1) = Ixy(i,j);
                B(1,1) = -Ixt(i,j);
                B(2,1) = -Iyt(i,j);      
                U=1/(A(1,1)*A(2,2)-A(1,2)*A(2,1))*[A(2,2) -A(1,2);-A(2,1) A(1,1)]*B;
                Vx(i,j) = U(1);      
                Vy(i,j) = U(2);
            end
        end
    case "LK_iterative"
        % YOUR IMPLEMENTATION GOES HERE
        % Window size for Basketball
        m = m_basketball;
        
        % Window size for Backyard
        %m = m_backyard;

        W = fspecial('gaussian',[m m],m/3);
        m_half = floor(m/2);
        Vx = zeros(size(im1));
        Vy = zeros(size(im1));
        A = zeros(2);
        B_temp = zeros(2,1);

        iterations = 3;
        for r = 1:iterations
            for i = 1+m_half:size(im1,1)-m_half
                for j = 1+m_half:size(im2,2)-m_half
                    
                     im2_patch = im2(i-m_half:i+m_half, j-m_half:j+m_half);
                     %moved patch 
                     y_min = round(i-m_half+Vy(i,j));
                     y_max = round(i+m_half+Vy(i,j));
                     x_min = round(j-m_half+Vx(i,j));
                     x_max = round(j+m_half+Vx(i,j));

                     if (y_min < 1)||(y_max > size(im1,1))||(x_min < 1)||(x_max > size(im1,2)) 

                     else
                         im1_patch = im1(y_min:y_max, x_min:x_max);
                         [Ix_1,Iy_1] = gradient(im1_patch);

                         fx = Ix_1;
                         fy = Iy_1;
                         Ixx2 = conv2(fx.*fx, W, 'valid');
                         Iyy2 = conv2(fy.*fy, W, 'valid');
                         Ixy2 = conv2(fx.*fy, W, 'valid');
                         A(1,1) = Ixx2;
                         A(2,2) = Iyy2;
                         A(1,2) = Ixy2;
                         A(2,1) = Ixy2;
                         ft = im2_patch-im1_patch;
                         Ixt_temp = conv2(fx.*ft, (1/m^2)*ones(m),'valid');
                         Iyt_temp = conv2(fy.*ft, (1/m^2)*ones(m),'valid');
                         B_temp(1,1) = -Ixt_temp;
                         B_temp(2,1) = -Iyt_temp;
                         X = 1/(A(1,1)*A(2,2)-A(1,2)*A(2,1))*[A(2,2) -A(1,2);-A(2,1) A(1,1)]*B_temp;

                         % If the update value is smaller than the threshold, we
                         % don't use it to update our previous velocity
                         % vector
                         thre = 1.0;
                         if abs(X(1)) < thre && abs(X(2)) >= thre
                             Vy(i,j) = Vy(i,j)+X(2);                                
                             continue;
                         elseif abs(X(1)) >= thre && abs(X(2)) < thre
                             Vx(i,j) = Vx(i,j)+X(1);      
                             continue;
                         elseif abs(X(1)) < thre && abs(X(2)) < thre
                             continue;
                         end
                         Vx(i,j) = Vx(i,j)+X(1);      
                         Vy(i,j) = Vy(i,j)+X(2);
                            
                     end
                 end
             end
        end

    case "LK_pyramid"
        % YOUR IMPLEMENTATION GOES HERE
        % Window size for Basketball
       % m_temp= m_basketball;
       
       % Window size for Backyard
       %m_temp = m_backyard;
       
       % Window size for Schfflera
       m_temp = 55;
       
        m_half = floor(m_temp/2);
        W_temp = fspecial('gaussian',[m_temp m_temp],m_temp/3);        
        t0 = clock;
        iterations=3;
        
        % Construct pyramids for im1 and im2
        im1_pyramid = construct_pyramid(im1);
        im2_pyramid = construct_pyramid(im2);

        %Processing all levels
        for k = length(im1_pyramid):-1:1
            % Current pyramid
            im1 = im1_pyramid{k};
            im2 = im2_pyramid{k};
            
            % Initialization
            if k==length(im1_pyramid)
                Vx = zeros(size(im1));
                Vy = zeros(size(im1));
            else
                % Resize the velocity vector
                Vx = imresize(Vx,2);
                Vy = imresize(Vy,2);

            end
                            
           for r = 1:iterations
                for i = 1+m_half:size(im1,1)-m_half
                    for j = 1+m_half:size(im2,2)-m_half
                        im2_patch = im2(i-m_half:i+m_half, j-m_half:j+m_half);
                        %moved patch 
                        y_min = round(i-m_half+Vy(i,j));
                        y_max = round(i+m_half+Vy(i,j));
                        x_min = round(j-m_half+Vx(i,j));
                        x_max = round(j+m_half+Vx(i,j));

                        if (y_min < 1)||(y_max > size(im1,1))||(x_min < 1)||(x_max > size(im1,2)) 

                        else
                            im1_patch = im1(y_min:y_max, x_min:x_max);
                            [Ix_1,Iy_1] = gradient(im1_patch);

                            fx = Ix_1;
                            fy = Iy_1;
                            Ixx2 = conv2(fx.*fx, W_temp, 'valid');
                            Iyy2 = conv2(fy.*fy, W_temp, 'valid');
                            Ixy2 = conv2(fx.*fy, W_temp, 'valid');
                            A(1,1) = Ixx2;
                            A(2,2) = Iyy2;
                            A(1,2) = Ixy2;
                            A(2,1) = Ixy2;
                            ft = im2_patch-im1_patch;
                            Ixt_temp = conv2(fx.*ft, (1/m_temp^2)*ones(m_temp),'valid');
                            Iyt_temp = conv2(fy.*ft, (1/m_temp^2)*ones(m_temp),'valid');
                            B_temp(1,1) = -Ixt_temp;
                            B_temp(2,1) = -Iyt_temp;
                            X = 1/(A(1,1)*A(2,2)-A(1,2)*A(2,1))*[A(2,2) -A(1,2);-A(2,1) A(1,1)]*B_temp;
                            
                         % If the update value is smaller than the threshold, we
                         % don't use it to update our previous velocity
                         % vector
                            thre = 1.0;
                            if abs(X(1)) < thre && abs(X(2)) >= thre
                                Vy(i,j) = Vy(i,j)+X(2);                                
                                continue;
                            elseif abs(X(1)) >= thre && abs(X(2)) < thre
                                Vx(i,j) = Vx(i,j)+X(1);      
                                continue;
                            elseif abs(X(1)) < thre && abs(X(2)) < thre
                                continue;
                            end
                            Vx(i,j) = Vx(i,j)+X(1);      
                            Vy(i,j) = Vy(i,j)+X(2);
                            
                        end
                    end
                end
           end
           etime(clock,t0)
         
        end
end
end

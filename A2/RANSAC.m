function RANSAC(row_idx,col_idx,theta)

% Set repeat time T where T is much less than N (#edge pixels)
T = 200;
inliers = {};
outliers = {};
% Create cells to store coordinate points on the line model
x_coord = [];
y_coord = [];

for count=1:T
    
    % Create temporary storage for inliers and outliers
    temp_inliers = {};
    temp_outliers = {};
    in_count = 1;
    out_count = 1;
    % Randomly sample an edge point from the list of edge points
    [imax,temp] = size(row_idx);
    index = randi(imax);
    samp_pt = [col_idx(index),row_idx(index),theta(index)];
    
    % Define the line model
    x_coord_temp = [1:max(row_idx)];
    x_coord_temp = x_coord_temp';
    % Get the direction of line model
    line_ang = 0;
    if samp_pt(3)>0
        line_ang = samp_pt(3)-pi/2;
    elseif samp_pt(3)<0
        line_ang = samp_pt(3)+pi/2;
    else
        line_ang = samp_pt(3);
    end    
    y_coord_temp = samp_pt(2)+(x_coord_temp-samp_pt(1))*tan(line_ang);
    
    % Calculate the cardinality of the concensus set
    num_in = 0;
    max_card = 0;
    for i=1:imax
        pt = [col_idx(i),row_idx(i)];
        % Decide if the point is an inlier
        % The inlier criterion being: set a threshold, if the distance of a
        % point to the closest point on the line model is smaller than the threshold, then mark
        % it as a candidate. Then set another threshold for angle, if the
        % difference between the gradeint orientation of the candidate and
        % the sample point is smaller than the angle threshold, then it
        % becomes an inlier.
        dist_thre = 4.5;
        ang_thre = 1;
        dist = sqrt(sum((pt-[x_coord_temp,y_coord_temp]).^2,2));% Calculate the euclidean distance of 2 points
        % Find the smallest one among all the distances
        min_dist = min(dist);
        if min_dist<=dist_thre
            if abs(theta(i)-samp_pt(3))<=ang_thre
                num_in = num_in+1;
                temp_inliers{in_count}=pt;
                in_count=in_count+1;
                %disp(i);   
            else
                temp_outliers{out_count}=pt;
                out_count=out_count+1;
            end
        else
                temp_outliers{out_count}=pt;
                out_count=out_count+1;
        end
        
    end
    
    if num_in > max_card
        inliers = {};
        max_card = num_in;
        temp_inliers = temp_inliers';
        len = size(temp_inliers);
        for i=1:len
            inliers{end+1} = cell2mat(temp_inliers(i));
        end
    end
end

% Get inliers
x_in = [];
y_in = [];
[temp,total]=size(inliers);
for i=1:total
x_in(i) = inliers{i}(1);
y_in(i) = inliers{i}(2);
end

figure
hold on
% Plot outliers
x_out = [];
y_out = [];
[all_pts,temp]=size(row_idx);
for i=1:all_pts
    flag = false; % determine if a point in an inlier
    temp_x = find(x_in==col_idx(i));
    temp_y = find(y_in==row_idx(i));
    [a,len]=size(temp_x);
    for j=1:len
        idx=find(temp_y==temp_x(j));
        if length(idx) ~= 0
            flag = true;
            break; 
        end
    end    
    if flag == true
        continue;
    else
    x_out = [x_out,col_idx(i)];
    y_out = [y_out,row_idx(i)];
    end
end
plot(x_out(:),y_out(:),'k.');

% Plot inliers
plot(x_in(:),y_in(:),'r.');

hold off
end
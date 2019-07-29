function points = find_extrema(up_level,mid_level,low_level,mid_sigma,thre,grad_thre)

% Create a cell array to store points
points = {};
index=1;

up_level = imresize(up_level,0.5);
low_level = imresize(low_level,2);

% Then we loop through all the pixels in the middle level image to find 
[rows,cols] = size(mid_level);

for i=2:rows-1
    for j=2:cols-1
        % Check if the central point is extrema 
        temp_min = min(min(mid_level(i-1:i+1,j-1:j+1)));
        temp_max = max(max(mid_level(i-1:i+1,j-1:j+1)));
        flag_min = (mid_level(i,j)==temp_min)&&(length(find(mid_level(i-1:i+1,j-1:j+1)==temp_min))==1);
        if flag_min==true
           flag1 = (temp_min< min(min(up_level(i-1:i+1,j-1:j+1))));
           if flag1==true
               flag2 = (temp_min< min(min(low_level(i-1:i+1,j-1:j+1))));
               if flag2==true  
                    if abs(mid_level(i,j))>= thre
                        grad = max([abs(mid_level(i,j)-mid_level(i-1,j)) abs(mid_level(i,j)-mid_level(i+1,j)) abs(mid_level(i,j)-mid_level(i,j-1)) abs(mid_level(i,j)-mid_level(i-1,j))]);
                        if grad>=grad_thre & grad<=30
                            points{index}{1,1,1} = {j,i,mid_sigma};
                            index = index+1;  
                            continue;
                        end
                    end
               end
           end
        end
        
        flag_max = (mid_level(i,j)==temp_max)&&(length(find(mid_level(i-1:i+1,j-1:j+1)==temp_max))==1);
        if flag_max==true
           flag1 = (temp_max> max(max(up_level(i-1:i+1,j-1:j+1))));
           if flag1==true
               flag2 = (temp_max> max(max(low_level(i-1:i+1,j-1:j+1))));
               if flag2==true
                   if abs(mid_level(i,j))>=thre
                        grad = max([abs(mid_level(i,j)-mid_level(i-1,j)) abs(mid_level(i,j)-mid_level(i+1,j)) abs(mid_level(i,j)-mid_level(i,j-1)) abs(mid_level(i,j)-mid_level(i-1,j))]);
                        if grad>=grad_thre& grad<=30
                            points{index}{1,1,1} = {j,i,mid_sigma};
                            index = index+1;
                        end
                   end
               end
           end
        end
          
    end
end

end
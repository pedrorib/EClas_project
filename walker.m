function [t_x,t_y] = walker(map,x_map,y_map,s_x,s_y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
while true
    move = rand();
    if move < 1/8
        t_x = s_x-1;
        t_y = s_y-1;
    elseif move < 2/8 && move >= 1/8
        t_x = s_x-1;
        t_y = s_y;
    elseif move < 3/8 && move >= 2/8
        t_x = s_x-1;
        t_y = s_y+1;
    elseif move < 4/8 && move >= 3/8
        t_x = s_x;
        t_y = s_y+1;
    elseif move < 5/8 && move >= 4/8
        t_x = s_x+1;
        t_y = s_y+1;
    elseif move < 6/8 && move >= 5/8
        t_x = s_x+1;
        t_y = s_y;
    elseif move < 7/8 && move >= 6/8
        t_x = s_x+1;
        t_y = s_y-1;
    else
        t_x = s_x;
        t_y = s_y-1;
    end
    if (t_x <= x_map-1) && (t_y <= y_map-1)
        if getOccupancy(map,[t_x t_y]) == 0
            break;
        end
    end
end
end


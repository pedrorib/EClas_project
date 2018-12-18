function [pi] = Pi(map,x,y)
%TRANSITION Computes the robot transition matrix
%   Detailed explanation goes here

pi = zeros(map.GridSize);
hyp = 0;
for i = -1:1
    for j = -1:1
        if (getOccupancy(map,[x+i y+j]) == 0)
            if (i == j && j == 0)
                continue;
            end
            pi(y+j,x+i) = 1;
            hyp = hyp + 1;
        end
    end
end
pi = pi / hyp;
end


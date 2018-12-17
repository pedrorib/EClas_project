function [transition,soutput] = Transition(map,x,y)
%TRANSITION Computes the robot transition matrix
%   Detailed explanation goes here

transition = zeros(map.GridSize);
soutput = zeros(3,3);
hyp = 0;
k = 1;
for i = -1:1
    for j = -1:1
        if (getOccupancy(map,[x+i y+j]) == 0)
            if (i == j && j == 0)
                continue;
            end
            transition(y+j,x+i) = 1;
            soutput(2+j,2+i) = 1;
            hyp = hyp + 1;
            k = k + 1;
        end
    end
end
transition = transition / hyp;
soutput = reshape(soutput.',[],1);
end


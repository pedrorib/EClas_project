clc;
clear all;
close all;
clf;

xmap=20; %length of map
ymap=20; %widtth of map
  
% Create an occupancy grid map and set obstacle locations.
map = robotics.BinaryOccupancyGrid(xmap,ymap,1);
xy = [10 10; 11 11; 10 11];    %obstacles
right = [];
down = [];
up = [];
left = [];

width = 1;      %obstacle measures 
height = 1;

for i = 0:xmap
    r = [0 i];                 
    right = [right; r];     %right wall 
    d = [i 0];
    down = [down; d];       %down wall
    u = [i 20];
    up = [up; u];           %up wall
    l = [20 i];
    left = [left; l];       %left wall
end

obs = [right; down; up; left; xy];
setOccupancy(map,[right; down; up; left; xy],1);     %obstacule is '1' and without is '0'

% Display the map, originial points, and set the axes limits to zoom in. You
% can see how the edge points affect the entire grid location status.

show(map)   %draw the obstacles
hold on
%plot((xy(:,1)- 0.5),(xy(:,2)-0.5),'xr','MarkerSize', 10)
%grid on
%set(gca,'XTick',0:1:20,'YTick',0:1:20)
%xlim([0 xmap])
%ylim([0 ymap])

%title('Robot Move Randomly')

%for i = 1:length(obs)    %draw the obstacles (not used)
%    rectangle('position',[obs(i,1),obs(i,2),width,height],'facecolor','black');
%end

% initialize point
s_x = round((rand()+rand())*10);         %create the starting point
s_y = round((rand()+rand())*10);

while getOccupancy(map,[s_x s_y]) == 1   %check if the point is an obstacle
    s_x = round((rand()+rand())*10);      %create a new starting point 
    s_y = round((rand()+rand())*10);
end

%create the robot
plot(s_x-0.5, s_y-0.5,'o', 'MarkerEdgeColor','b', ...
        'MarkerFaceColor','b','MarkerSize', 10)
grid on
set(gca,'XTick',0:1:xmap,'YTick',0:1:ymap)

drawnow;
i=0;
j = 0;
increaseI = true;
while increaseI    
  if (i > 10)
     increaseI = false;
     %i = i-5;
  end

  if(s_x <= xmap-1) && (s_x <= ymap-1) 
     if (rand() > 0.5)                     %to random select if the robot go up
         s_x = round(s_x+rand());
         s_y = round(s_y+rand());
     else
         s_x = round(s_x-rand());
         s_y = round(s_y-rand());
     end
  else
    s_x = round(s_x-rand());
    s_y = round(s_y-rand());
  end

  if (s_x <= 1)
    s_x = round(s_x+rand());
  end

  if (s_y <= 1)
     s_y = round(s_y+rand());
  end    

  if (getOccupancy(map,[s_x s_y]) == 0) %avoid collision
      i = i + 1;
      
      show(map);
      hold on;
      plot(s_x-0.5, s_y-0.5,'o', 'MarkerEdgeColor','b', ...
        'MarkerFaceColor','b','MarkerSize', 10)
      set(gca,'XTick',0:1:20,'YTick',0:1:20);
      grid on;
      
      drawnow;                                    %# force refresh
      pause (1);
  end

end

%getOccupancy(map,[1 1])
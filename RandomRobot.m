clear all;
close all;


xmap=20; %length of map
ymap=20; %width of map
  
% Create an occupancy grid map and set obstacle locations.
map = robotics.BinaryOccupancyGrid(xmap,ymap,1);
xy = [10 10; 11 11; 10 11];    %obstacles
right = [];
down = [];
up = [];
left = [];

width = 1;      %obstacle measures 
height = 1;

xlab = 1:1:20; %heatmap labels
ylab = 20:-1:1;

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

f1 = figure('Name','Robot','Position',[100 100 500 500]);
ax1 = axes(f1);

% Display the map, originial points, and set the axes limits to zoom in. You
% can see how the edge points affect the entire grid location status.

show(map,'Parent',ax1);   %draw the obstacles
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

 
tran = [];
for s_x = 2:19 % Calculates transition matrix (tran)
    for s_y = 2:19
        temp = Transition(map,s_x,s_y);
        temp = temp(2:end-1,2:end-1);
        tran = [tran; reshape(temp.',1,[]);];
    end
end
    
s_x = round((rand()+rand())*10);         %create the starting point
s_y = round((rand()+rand())*10);

while getOccupancy(map,[s_x s_y]) == 1   %check if the point is an obstacle
    s_x = round((rand()+rand())*10);      %create a new starting point 
    s_y = round((rand()+rand())*10);
end

%create the robot
plot(ax1,s_x-0.5, s_y-0.5,'o', 'MarkerEdgeColor','b', ...
        'MarkerFaceColor','b','MarkerSize', 10)
grid on
set(gca,'XTick',0:1:xmap,'YTick',0:1:ymap)

i=0;
j = 0;

A = Transition(map,s_x,s_y);
f2 = figure('Name', 'Transition matrix','Position',[650 25 650 650]);
h=heatmap(f2, flipud(A));
h.CellLabelFormat = '%.2f';
h.ColorbarVisible = 'off';
h.FontSize = 8;
drawnow;

sensor = zeros(9,1);

  
while true    
  if (i > 10)
     break;
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
      
      show(map,'Parent',ax1);
      hold(ax1,'on');
      plot(ax1,s_x-0.5, s_y-0.5,'o', 'MarkerEdgeColor','b', ...
        'MarkerFaceColor','b','MarkerSize', 10)
      set(ax1,'XTick',0:1:20,'YTick',0:1:20);
      grid(ax1,'on');
      
      A = Transition(map,s_x,s_y);
%       h = heatmap(f2,xlab, ylab, flipud(A));
%       h.FontSize = 8;
%       h.CellLabelFormat = '%.2f';
%       h.ColorbarVisible = 'off';  
      

      A = A(2:end-1,2:end-1);
      A = reshape(A.',1,[]);
      for i = -1:1
          for j = -1:1
              if (getOccupancy(map,[x+i y+j]) == 0)
                  if (i == j && j == 0)
                      continue;
                  end
                  %calcular matriz do sensor
              end
          end
      end
      drawnow;                                    %# force refresh
      pause(1);
  end

end

%getOccupancy(map,[1 1])
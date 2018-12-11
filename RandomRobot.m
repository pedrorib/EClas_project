clc;
clear all;
close all;
clf;

%Grid Map
xmap=20; %length of map
ymap=20; %widtth of map

% Create an occupancy grid map and set obstacle locations.
map = robotics.BinaryOccupancyGrid(xmap,ymap,1);
xy = [10 10; 11 11; 10 11];    %obstacles
xx = [];
yy = [];
for i = 0:xmap-1
    px = [0 i];
    xx = [xx; px];
    py = [i 0];
    yy = [yy; py];
end
setOccupancy(map,xy,1);
setOccupancy(map,xx,1);
setOccupancy(map,yy,1);

% Display the map, originial points, and set the axes limits to zoom in. You
% can see how the edge points affect the entire grid location status.

pos=[];

for i=1:xmap
    for j=1:ymap
        pos_t = [i ; j];
        pos = [pos pos_t];
    end
end
%Sp = [5 4]; %%%%Define the starting point of the robot
%Tp = [1 4];

%show(map)
%hold on
%plot((xy(:,1)- 0.5),(xy(:,2)-0.5),'xr','MarkerSize', 10)
%grid on
%set(gca,'XTick',0:1:20,'YTick',0:1:20)
%xlim([0 xmap])
%ylim([0 ymap])
%# setup a figure and axis
%hFig = show(map);
hFig = figure('Backingstore','off', 'DoubleBuffer','on');
hAx = axes('Parent',hFig, 'XLim',[0 xmap], 'YLim',[0 ymap], ...
          'Drawmode','fast', 'NextPlot','add');
axis(hAx, 'on','square');
%# initialize point
title('Robot Move Randomly')
grid on;
%axes =[0 xmap 0 ymap];

for i = 1:length(xy)
    %point_x = xy(i,1);
    %point_y = xy(i,2);
    %h = fill([point_x-1,point_x,point_x,point_x-1],[point_y-1,point_y-1,point_y,point_y],'black');
    %set(h,'EraseMode','xor');
    %set(h);
    %or
    width = 1;
    height = 1;
    rectangle('position',[xy(i,1),xy(i,2),width,height],'facecolor','black')
    %plot((xy(:,1)-0.5),(xy(:,2)-0.5),'Square', 'MarkerEdgeColor','black', ...
    %    'MarkerFaceColor','black','MarkerSize', 1)
end

for i = 0:ymap
    rectangle('position',[0,i,width,height],'facecolor','black');
    rectangle('position',[i,0,width,height],'facecolor','black');
    rectangle('position',[19,i,width,height],'facecolor','black');
    rectangle('position',[i,19,width,height],'facecolor','black')
end
set(gca,'XTick',0:1:xmap,'YTick',0:1:ymap)
%set(gcf,'Renderer','OpenGL');
%or pos(1,1)
s_x = int8((rand()+rand())*10); %create the starting point
s_y = int8((rand()+rand())*10);

while getOccupancy(map,[s_x s_y]) == 1   %check if the point is an obstacle
    s_x = int8((rand()+rand())*10);       %create a new starting point 
    s_y = int8((rand()+rand())*10);
end
    
h = rectangle('position',[s_x,s_y,1,1],'facecolor','b','EraseMode','normal', ...
    'Parent', hAx);
%h = fill([s_x-1,s_x,s_x,s_x-1],[s_y-1,s_y-1,s_y,s_y],'b')
%h = plot(pos(1)-0.5,pos(1)-0.5,'o','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
set(h,'EraseMode','normal');

drawnow update;
i=0;
j = 0;
increaseI = true;
while increaseI
  %if (increaseI)
  %    i = i + 1;
  %end    
  if (i > 10)
     increaseI = false;
     %i = i-5;
  end
  %if (i < 1) 
  %   increaseI = true;
  %   i = i +5;
  %end

 if(s_x <= xmap) && (s_x <= ymap) 
     if (rand() > 0.5)                     %to random select if the robot go up
         s_x = int8(s_x+rand());
         s_y = int8(s_y+rand());
     else
         s_x = int8(s_x-rand());
         s_y = int8(s_y-rand());
     end
 else
    s_x = int8(s_x-rand());
    s_y = int8(s_y-rand());
 end

 if (s_x <= 0)
    s_x = int8(s_x+rand());
 end

 if (s_y <= 0)
     s_y = int8(s_y+rand());
 end    

    if (getOccupancy(map,[s_x s_y]) == 0) %avoid collision
      i = i + 1;

      hAx = axes('Parent',hFig, 'XLim',[0 xmap], 'YLim',[0 ymap], ...
          'Drawmode','fast', 'NextPlot','add');
      axis(hAx, 'on','square');
      set(gca,'XTick',0:1:20,'YTick',0:1:20);
      grid on;
      
      %h = fill([s_x-1,s_x,s_x,s_x-1],[s_y-1,s_y-1,s_y,s_y],'b');
      %set(h,'EraseMode','normal');
      rectangle('position',[s_x,s_y,1,1],'facecolor','b','EraseMode','normal', ...
            'Parent', hAx);
        
      %set(h)%,'XData',s_x, 'YData',s_y)    %# update X,Y data
      %set(hTxt,'String',num2str(t(i)))         %# update angle text
      drawnow update;                                    %# force refresh
      pause (1);
    end

end

%getOccupancy(map,[1 1])
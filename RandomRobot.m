clear all;
close all;


xmap=20; %length of map
ymap=20; %width of map
  
% Create an occupancy grid map and set obstacle locations.
map = robotics.BinaryOccupancyGrid(xmap,ymap,1);
%xy = [10 10; 11 11; 10 11];    %obstacles
xy = [2 11;3 11;4 11;5 11;6 11;7 11;8 11;11 2;11 3;11 4;11 5;11 6;11 7;11 8;13 11;14 11;15 11;16 11;17 11;18 11;19 11;11 13;11 14;11 15;11 16;11 17;11 18;11 19];
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
soutput = [];
for s_y = 2:19 % Calculates transition matrix (tran)
    for s_x = 2:19
        [temp,stemp] = Transition(map,s_x,s_y);
        temp = temp(2:end-1,2:end-1);
        tran = [tran; reshape(temp.',1,[]);];
        soutput = [soutput; reshape(stemp.',1,[]);];
    end
end
    
s_x = round((rand()+rand())*10);         %create the starting point
s_y = round((rand()+rand())*10);

while getOccupancy(map,[s_x s_y]) == 1   %check if the point is an obstacle
    s_x = round((rand()+rand())*10);      %create a new starting point 
    s_y = round((rand()+rand())*10);
end

% s_x = 10;
% s_y = 9;

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

%INITIALIZATION
pi0 = ones(18,18);
%pi0 = pi0;
pi0 = reshape(pi0.',[],1);
pi0 = pi0/sum(pi0);
[A,~] = Transition(map,s_x,s_y);
sensor = ceil(A(s_y-1:s_y+1,s_x-1:s_x+1));
A = A(2:end-1,2:end-1);
A = reshape(A.',1,[]);
sensor = reshape(sensor.',1,[]);
B = pplace(soutput, sensor, 18*18);
alphap = B*pi0;
alpha = [];

while true    
  if (i > 10000)
     break;
  end
  
  [s_x,s_y] = walker(map,xmap,ymap,s_x,s_y);
  
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
      
      %       h = heatmap(f2,xlab, ylab, flipud(A));
      %       h.FontSize = 8;
      %       h.CellLabelFormat = '%.2f';
      %       h.ColorbarVisible = 'off';
      
      [A,~] = Transition(map,s_x,s_y);
      sensor = ceil(A(s_y-1:s_y+1,s_x-1:s_x+1));
      A = A(2:end-1,2:end-1);
      A = reshape(A.',1,[]);
      sensor = reshape(sensor.',1,[]);
      B = pplace(soutput, sensor, 18*18);
      alpha = B*tran'*alphap;
      malpha = reshape(alpha,[18,18]);
      heatmap(f2,2:19,19:-1:2, flipud(malpha'));

      drawnow;                                    %# force refresh
      pause(1);
  end
  alphap = alpha;

end

%getOccupancy(map,[1 1])
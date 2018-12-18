clear all;
close all;

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

show(map,'Parent',ax1);   %draw the obstacles
hold on

%initialize point
  
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

%inicialization matrix
alfa = Pi(map,s_x,s_y);
f2 = figure('Name', 'state matrix','Position',[650 25 650 650]);
h=heatmap(f2, flipud(alfa));
h.CellLabelFormat = '%.3f';
h.ColorbarVisible = 'off';
h.FontSize = 8;
drawnow;

pi = reshape(alfa,[],1);    %vector with matrix pi (N*1)

%create obstacle matrix
b = ones(map.GridSize);
for j = 1:ymap
    for i = 1:xmap
        if getOccupancy(map,[i j]) == 1
            b(j,i) = 0;
        end
    end
end

B = reshape(b,[],1);          %vetor (N*1) with obstacles
%A = G_Transition(xmap,ymap);   

m = test_t(pi,B,1,xmap).';  %generate the transition matrix (output uncertainty vetor)

mat = reshape(m,[xmap,ymap]); %convert vetor to matrix

f3 = figure('Name', 'Uncertainty matrix','Position',[650 25 650 650]);
h=heatmap(f3, xlab, ylab, flipud(mat));
h.CellLabelFormat = '%.4f';
h.ColorbarVisible = 'off';
h.FontSize = 8;
drawnow;

t = 1000;
step=0;
while true    
  if (step >= t)
     break;
  end
     
  if(s_x <= xmap-1) && (s_y <= ymap-1) 
     if (rand(1) > 0.5)                     %to random select if the robot go up
         %ra = rand(1)
         s_x = round(s_x+rand(1));
         s_y = round(s_y+rand(1));
         disp('first')
     else                                   %go down
         %ra = rand(1)
         s_x = round(s_x-rand(1));
         s_y = round(s_y-rand(1));
         disp('second')
     end
  else
    s_x = round(s_x-rand(1));
    s_y = round(s_y-rand(1));
    disp('third')
  end

  if (s_x <= 1)
    s_x = round(s_x+rand(1));
  end

  if (s_y <= 1)
     s_y = round(s_y+rand(1));
  end    

  if (getOccupancy(map,[s_x s_y]) == 0) %avoid collision
      step = step + 1;
      
      show(map,'Parent',ax1);
      hold(ax1,'on');
      plot(ax1,s_x-0.5, s_y-0.5,'o', 'MarkerEdgeColor','b', ...
        'MarkerFaceColor','b','MarkerSize', 10)
      set(ax1,'XTick',0:1:20,'YTick',0:1:20);
      grid(ax1,'on');
      
      alfa = Pi(map,s_x,s_y);
      h = heatmap(f2,xlab, ylab, flipud(alfa));
      h.FontSize = 8;
      h.CellLabelFormat = '%.3f';
      h.ColorbarVisible = 'off';
      drawnow;
      
      pi = reshape(alfa,[],1);    %vector with matrix pi (N*1)
      
      u_vetor = test_t(pi,B,2,xmap).';

      u_matri = reshape(u_vetor,[xmap,ymap]); %convert vetor to matrix
 
     h = heatmap(f3, xlab, ylab, flipud(u_matri));
      h.CellLabelFormat = '%.4f';
      h.ColorbarVisible = 'off';
      h.FontSize = 8;
      drawnow;                                    %# force refresh
      pause(1);
   end
 
end

%without grid through funtion
mapa = createMapFromName('map');
show(mapa);

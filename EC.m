%Grid Map

% Create an occupancy grid map and set obstacle locations.
map = robotics.BinaryOccupancyGrid(20,20,1);
xy = [5 5; 4 4; 6 3];    %obstacles
setOccupancy(map,xy,1);

% Display the map, originial points, and set the axes limits to zoom in. You
% can see how the edge points affect the entire grid location status.

show(map);
hold on
plot((xy(:,1)- 0.5),(xy(:,2)-0.5),'xr','MarkerSize', 10)
grid on
set(gca,'XTick',0:1:20,'YTick',0:1:20)
xlim([0 20])
ylim([0 20])

%when its occupied is '1'
cell = getOccupancy(map,[5 5])
%free is '0'
getOccupancy(map,[1 0])
getOccupancy(map,[10 10])

function []=visualize()
rng(1)
data = h5read('planB_data.h5','/myDataset/0002');

detection_R = 5;
detection_h_angle = 2*pi/3;
n = 6; % number of cones per side 
order =3;
dist=0.7; % lane width/2

cone_placement(detection_R, detection_h_angle, n, dist, order);
close all;
cone_placement(detection_R, detection_h_angle, n, dist, order);
plot3(data(1,:),data(2,:),data(3,:),'.','markeredgecolor',[0 0 0]);
set(gca, 'position',[0,0,1,1], 'projection','perspective','xtick',[],...
    'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
view(3)
% ax=gca;
% set(gca,'cameraposition',[0,-10,10])
% ax.CameraPosition  = [0 0 50];
% ax.CameraTarget    = [0 2.5 0];
% ax.CameraUpVector  = [0 1 0];
% ax.CameraViewAngle =  10;

% ax=gca;
% set(gca,'cameraposition',[0,-10,10])
% ax.CameraPosition  = [0 -0.6 0.8];
% ax.CameraTarget    = [0 2.5 0];
% % ax.CameraUpVector  = [0 0 1];/
% ax.CameraViewAngle =  90;

axis equal
end
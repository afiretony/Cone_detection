function [conex,coney]=cone_placement(detection_R, detection_h_angle, n, dist, order)
% [a,b]=cone_placement(20,2*pi/3,15,1);

close all;

detection_range_x =[0,detection_R*cos(linspace((pi-detection_h_angle)/2,pi-(pi-detection_h_angle)/2,100)),0]; 
detection_range_y =[0,detection_R*sin(linspace((pi-detection_h_angle)/2,pi-(pi-detection_h_angle)/2,100)),0]; 

pathx =[-0.1,linspace(0, 0.8*detection_R,4)];
pathy = (-0.5+1*rand(1,5))*tan(detection_h_angle/2).*pathx;
pathx=[pathx,25];
pathy = [pathy,0];
pathy(1)=0;

p = polyfit(pathx,pathy,order);
b = polyval(p,(0:0.01:detection_R));

db = diff(b)/(0.01);

deg = atan(db);
p1x = (0.01:0.01:detection_R) - dist*sin(deg);
p1y = b(2:length(b)) + dist*cos(deg);
p2x = (0.01:0.01:detection_R) + dist*sin(deg);
p2y = b(2:length(b)) - dist*cos(deg);

cone_xy_l = curvspace([p1y;p1x]',n);
cone_xy_r = curvspace([p2y;p2x]',n);
conex = [cone_xy_l(:,1);cone_xy_r(:,1)];
coney = [cone_xy_l(:,2); cone_xy_r(:,2)];
[in,on] = inpolygon(conex,coney,detection_range_x,detection_range_y);
conex = conex(in&~on);
coney = coney(in&~on);

% % visualize
% figure('color',[1,1,1])
% patch(detection_range_x,detection_range_y,-0.01*ones(1,length(detection_range_y)),[1,0.9,0.9]);
% 
% hold on;
% plot(b, (0:0.01:detection_R),'--')
% plot(p1y,p1x,'r-','linewidth',2)
% plot(p2y,p2x,'b-', 'linewidth',2)
% patch([p2y,flip(p1y)],[p2x,flip(p1x)],0.0*ones(1, 2*length(p2x)),[1 1 1]*0.6)
% plot(conex,coney,'r^','markersize',6); % points strictly inside
% set(gca,'xlim',[-detection_R,detection_R],'ylim',[0,2*detection_R])

end
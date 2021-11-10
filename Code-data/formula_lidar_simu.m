clc;clear;close all;
h = 0.4; %height of lidar
P = [0,0,h]; % position of lidar
syms x0 y0
position = [x0,y0]; % Cone position

hcone = 0.3; % Cone height
R = 0.1; % Cone radius
a = R/hcone; 
b = R/hcone; 
c = 1; 

detection_h_angle = deg2rad(120);
detection_R = 20;
detection_range_x =[0,detection_R*cos(linspace((pi-detection_h_angle)/2,pi-(pi-detection_h_angle)/2,100)),0]; 
detection_range_y =[0,detection_R*sin(linspace((pi-detection_h_angle)/2,pi-(pi-detection_h_angle)/2,100)),0]; 
figure('color',[1,1,1])
objecth3 = patch(detection_range_x,detection_range_y,[1,0.9,0.9]);

pathx =[-0.1,linspace(0, 0.8*detection_R,4)];
pathy = (-0.5+1*rand(1,5))*tan(detection_h_angle/2).*pathx;
pathx=[pathx,25];
pathy = [pathy,0];
pathy(1)=0;

p = polyfit(pathx,pathy,4);
b = polyval(p,(0:0.01:detection_R));

db = diff(b)/(0.01);
dist=1;
deg = atan(db);
p1x = (0.01:0.01:detection_R) - dist*sin(deg);
p1y = b(2:length(b)) + dist*cos(deg);
p2x = (0.01:0.01:detection_R) + dist*sin(deg);
p2y = b(2:length(b)) - dist*cos(deg);

n=15;
cone_xy_l = curvspace([p1y;p1x]',n);
cone_xy_r = curvspace([p2y;p2x]',n);

hold on;
objecth1 = plot(b, (0:0.01:detection_R),'--');
plot(p1y,p1x,'r-','linewidth',2)
plot(p2y,p2x,'b-', 'linewidth',2)

conex = [cone_xy_l(:,1);cone_xy_r(:,1)];
coney = [cone_xy_l(:,2); cone_xy_r(:,2)];
[in,on] = inpolygon(conex,coney,detection_range_x,detection_range_y);
conex = conex(in&~on);
coney = coney(in&~on);
objecth2 = plot(conex,coney,'r^','markersize',6); % points strictly inside
set(gca,'xlim',[-detection_R,detection_R],'ylim',[0,2*detection_R])
legend([objecth3,objecth1,objecth2],'Horizontal Scanning Range','Lane','Cones')


%%
syms k
point_x=[];
point_y=[];
point_z=[];

phi = linspace(pi/2+0.001, pi/2+pi/6, 16);
theta = linspace(-pi/6, pi/6, 20);


for i = 1:length(phi)
    disp(i)
    for j = 1:length(theta)
        r = [sin(phi(i))*cos(theta(j)), sin(phi(i))*sin(theta(j)), cos(phi(i))];
        ray_x = P(1)+r(1)*k;
        ray_y = P(2)+r(2)*k;
        ray_z = P(3)+r(3)*k;

        eqn1 = (ray_x-position(1))^2/a^2 +(ray_y-position(2))^2/b^2 -...
            (ray_z-hcone)^2/c^2 == 0;
        eqn2 = ray_z ==0;
        sol = vpasolve(eqn2,k);
        sol = double(sol);
        point_x(end +1) = double(subs(ray_x, k, sol));
        point_y(end +1) = double(subs(ray_y, k, sol));
        point_z(end +1) = double(subs(ray_z, k, sol));
        
        solk = vpasolve(eqn1,k,[0,2]);
        solk = double(solk);
        if ~isreal(solk) || isempty(solk)
            continue
        end
        solk = sort(solk);
        solk = solk(1);
        z_dim = double(subs(ray_z, k, solk));
        if z_dim>0 && z_dim < hcone
            point_x(end) = double(subs(ray_x, k, solk));
            point_y(end) = double(subs(ray_y, k, solk));
            point_z(end) = z_dim;
        end

    end
end

%%
figure()
ax=axes();
plot3(point_x,point_y, point_z,'.');
set(ax, 'Xlim',[0,1],'ylim',[-0.5,0.5],'zlim', [0,1]);
grid on;


%% no ground

h = 0.15; %height of lidar
P = [0,0,h]; % position of lidar

position = [0.5,0]; % Cone position
hcone = 0.3; % Cone height
R = 0.1; % Cone radius
a = R/hcone; 
b = R/hcone; 
c = 1; 


syms k;
point_x=[];
point_y=[];
point_z=[];

phi = linspace(pi/2-pi/12, pi/2+pi/6, 16);
theta = deg2rad(-30:0.4:30);
% phi =pi/2;
% theta =0;

for i = 1:length(phi)
    disp(i)
    for j = 1:length(theta)
        r = [sin(phi(i))*cos(theta(j)), sin(phi(i))*sin(theta(j)), cos(phi(i))];
        ray_x = P(1)+r(1)*k;
        ray_y = P(2)+r(2)*k;
        ray_z = P(3)+r(3)*k;

        eqn1 = (ray_x-position(1))^2/a^2 +(ray_y-position(2))^2/b^2 -...
            (ray_z-hcone)^2/c^2 == 0;
        solk = vpasolve(eqn1,k,[0,2]);
        solk = double(solk);
        if ~isreal(solk) || isempty(solk)
            continue
        end
        solk = sort(solk);
        solk = solk(1);
        z_dim = double(subs(ray_z, k, solk));
        if z_dim>0 && z_dim < hcone
            point_x(end+ 1) = double(subs(ray_x, k, solk));
            point_y(end+ 1) = double(subs(ray_y, k, solk));
            point_z(end+ 1) = z_dim;
        end

    end
end


%% syms
syms h %height of lidar
P = [0,0,h]; % position of lidar
syms x0 y0
position = [x0,y0]; % Cone position
syms hcone % Cone height
R = 0.1; % Cone radius
a = R/hcone; 
b = R/hcone; 
c = 1; 

syms k phi theta;
r = [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)];
ray_x = P(1)+r(1)*k;
ray_y = P(2)+r(2)*k;
ray_z = P(3)+r(3)*k;

eqn1 = (ray_x-position(1))^2/a^2 +(ray_y-position(2))^2/b^2 -...
    (ray_z-hcone)^2/c^2 == 0;
solk = vpasolve(eqn1,k);
function []=main()
clc;
rng(2)
num_scene = 50;

for i = 1:num_scene
    point_x=[];
    point_y=[];
    point_z=[];
    [point_x, point_y, point_z] = generator(point_x,point_y,point_z);
    h5create('all.h5',strcat('/myDataset/',num2str(i,'%04.f')),[3 Inf], 'ChunkSize',[3 3]);
     h5write('all.h5',strcat('/myDataset/',num2str(i,'%04.f')),[point_x;point_y;point_z],[1, 1],[3 length(point_x)]);
    close all;
end

end

function [point_x,point_y,point_z]=generator(point_x,point_y,point_z)
% calculate PCD 

detection_R = 5;
detection_h_angle = 2*pi/3;
n = 6; % number of cones per side 
order =3;
dist=0.7; % lane width/2

[conex,coney]=cone_placement(detection_R, detection_h_angle, n, dist, order);

num_cone = length(conex);


h=0.301; %height of lidar
P = [0,0,h]; % position of lidar

hcone = 0.3; % Cone height
R = 0.1; % Cone radius
a = R/hcone; 
b = R/hcone; 
c = 1; 

syms k phi theta;
r = [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)];
ray_x = P(1)+r(1)*k;
ray_y = P(2)+r(2)*k;
ray_z = P(3)+r(3)*k;

K = zeros(2, num_cone);
solk = sym(K);

% cones and ray
for i=1:num_cone
    temp_eqn = (ray_x-conex(i))^2/a^2 +(ray_y-coney(i))^2/b^2 -(ray_z-hcone)^2/c^2 == 0;
    solk(:,i) = solve(temp_eqn,k);
end

% ground and ray
eqn2 = ray_z ==0;
solk_g = solve(eqn2,k);



yaw =  pi-atan(detection_R/h)-0.2;
% yaw = pi/2-pi/12;
phis = linspace(yaw, yaw+pi/6, 16);
thetas = (-detection_h_angle/2:0.4/180*pi:detection_h_angle/2)+pi/2;

f = waitbar(0,'Please wait...');
f2 = waitbar(0,'Channel 1 progress');

for i = 1:length(phis)
    message = strcat('Generating Points from Channel',num2str(i));
    waitbar(i/length(phis),f,message);
    for j = 1:length(thetas)
        message = strcat('Channel ',num2str(i),' Progress');
        waitbar(j/length(thetas),f2,message);
        
        solk_ground = double(subs(solk_g,[theta,phi],[thetas(j),phis(i)]));
        solk_cone = double(subs(solk,[theta,phi], [thetas(j),phis(i)]));
        solk_cone(imag(solk_cone)~=0) = 999;
        min_cone = min(solk_cone, [],'all');
        mink = min(min_cone,solk_ground);
        if mink>(detection_R+0.1) || mink<=0
            continue
        end
        point_x(end +1) = double(subs(ray_x, [theta,phi,k],[thetas(j),phis(i), mink]));
        point_y(end +1) = double(subs(ray_y, [theta,phi,k],[thetas(j),phis(i), mink]));
        point_z(end +1) = double(subs(ray_z, [theta,phi,k],[thetas(j),phis(i), mink]));
    end
end
close(f)
close(f2)
end
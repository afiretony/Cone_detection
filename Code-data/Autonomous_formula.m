%Autonomous formula project
%Simulation

figureh = figure('Name', 'Driving simulation');
ax = axes('Position',[0 0 1 1]);
ax.XLim = [-200,200];
ax.YLim = [-50,400];
ax.ZLim = [0,200];
pbaspect([1 1 1]);
ax.CameraPosition  = [-200 -1000 300];
ax.CameraTarget    = [0 0 40];
ax.CameraUpVector  = [0 0.1 1];
ax.CameraViewAngle =  10;
ax.Projection = 'perspective';
hold on;

%car
width=20;
patch([width,width,-width,-width],[0 0 0 0],[0 10 10,0],'red')
patch([width,width,-width,-width],[-30 -30 -30 -30],[0 10 10,0],'red')
patch([width,width,width,width],[0 0 -30 -30],[0 10 10,0],'red')
patch(-[width,width,width,width],[0 0 -30 -30],[0 10 10,0],'red')
patch([width,width,-width,-width],[0 -30 -30 0],[10 10 10,10],'red')

%plane
patch([200,200,-200,-200],[-500 1000 1000 -500],[0 0 0,0],[.9 .9 .9],'edgecolor','none')
for i = 1:20
   r= i;
   X=r^2 * cos(linspace(0, pi, 50));
   Y=r^2 * sin(linspace(0, pi, 50));
   Z=zeros(1, 50);
   plot3(X,Y,Z,'.','Color',[.3,.3,.3])
end

%Cone
xdistance=40;
ydistance=40;

CGy=[colon(0,ydistance,200), colon(0,ydistance,200)];
CGx=[zeros(1, length(CGy)/2)+xdistance, zeros(1, length(CGy)/2)-xdistance];
for i=1:length(CGx)
    r = -linspace(0,2*pi,10) ;
    th = linspace(0,2*pi,10) ;
    [R,T] = meshgrid(r,th) ;
    Xc = R.*cos(T) +CGx(i);
    Yc = R.*sin(T) +CGy(i);
    Zc = 1.5 * R + 10 ;
    if Xc(1)>0
        plot3(Xc,Yc,Zc,'.','Color','yellow')
    else
        plot3(Xc,Yc,Zc,'.','Color','blue')
    end
    
end
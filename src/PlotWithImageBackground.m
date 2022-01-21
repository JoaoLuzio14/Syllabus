x = -175:175; 
y = -150*sind(x); 
h = figure(1);
h.Position = [100 100 1050 900];
plot(x,y,'linewidth',1); 
axis tight; 


I = imread('Map.PNG'); 
h = image(xlim,ylim,I); 
uistack(h,'bottom')

% Define position of arm
theta=0:10:360; %theta is spaced around a circle (0 to 360).
r=0.03; %The radius of our circle.
%Define a circular magenta patch.
x=r*cosd(theta) + 0.075;
y=r*sind(theta) + 1;
% Vehicle Model
x = [-0.283, -0.288, 1.383, 1.383];
y = [  0.32,  -0.32, -0.32, 0.32];
g = hgtransform;
myShape2 = patch('XData',x,'YData',y,'FaceColor','red','Parent',g);
set(myShape2,'Xdata',x,'Ydata',y);
axis([-175 175 -150 150]); grid on;

T=0.05; %Delay between images
for theta = pi/2:-pi/90:0
    if theta >= pi/4
        theta = theta;
    else
        theta = pi/2 - theta;
    end
    Arot = [sin(theta) cos(theta); -cos(theta) sin(theta)];
    xyRot = Arot * [x; y]; % rotates the points by theta
    xyTrans = xyRot; % translates all points by 0.1
    set(myShape2,'Xdata',(x+xyTrans(1, :)),'Ydata',(y+xyTrans(2, :)));
    pause(T); %Wait T seconds
end
  
pt1 = [-4 -4 0];
pt2 = [5 2 0];
for t=linspace(0,1,100)
  g.Matrix = makehgtform('translate',pt1 + t*(pt2-pt1));
  drawnow
end
for t=linspace(0,1,100)
  g.Matrix = makehgtform('translate',pt2 + t*(pt1-pt2));
  drawnow
end

r1 = 0;
r2 = -pi/2;
for t=linspace(0,1,100)
  g.Matrix = makehgtform('zrotate',r1 + t*(r2-r1));
  drawnow
end
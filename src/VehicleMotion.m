x = -175:175; 
y = -150*sind(x); 
h = figure(1);
h.Position = [100 100 1050 900];
plot(x,y,'linewidth',1); 
axis tight; 

I = imread('Map.PNG'); 
h = image(xlim,ylim,I); 
uistack(h,'bottom')

% Vehicle Model
x = [-0.283, -0.288, 1.383, 1.383];
y = [  0.32,  -0.32, -0.32, 0.32];
g = hgtransform;
myShape2 = patch('XData',x,'YData',y,'FaceColor','red','Parent',g);
set(myShape2,'Xdata',x,'Ydata',y);
axis([-175 175 -150 150]); grid on;

[p_final,~] = size(out.state);
for k=1:(p_final-1)
    pt1 = [out.state(k,1) out.state(k,2) 0];
    pt2 = [out.state(k+1,1) out.state(k+1,2) 0];
    r1 = out.state(k,3)*pi/180;
    r2 = out.state(k+1,3)*pi/180;
    for t=linspace(0,1,100)
      g.Matrix = makehgtform('translate',pt1 + t*(pt2-pt1),'zrotate',r1 + t*(r2-r1));
      drawnow
    end
end
clc
clear all;
close all;

out=sim('controller',100);

x0=500;
y0=20;
width=292;
height=586;

hold on
ylim=([-150 150]);
xlim=([-75 75]);
I = imread('mapa_4.png'); 
h = image(xlim,-ylim,I); 
uistack(h,'bottom')
set(gcf,'Position',[x0,y0,width,height])

% Vehicle Model
x = [-0.566, -0.566, 2.766, 2.766];
y = [  0.64,  -0.64, -0.64, 0.64];

g = hgtransform;
myShape2 = patch('XData',x,'YData',y,'FaceColor','red','Parent',g);
set(myShape2,'Xdata',x,'Ydata',y);
axis tight;


[p_final,~] = size(out.state);
for k=1:15:(p_final-1)
    disp(k);
    pt1 = [out.state(k,1) out.state(k,2) 0];
    r1 = round(out.state(k,3), 3);
    g.Matrix = makehgtform('translate',pt1,'zrotate',r1);
    drawnow
end
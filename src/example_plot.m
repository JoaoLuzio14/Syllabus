clc
clear all
close all; clc; clear;

out=sim('controller',50);

x = -150:150; 
y = 150*sind(x); 
axis tight; 
hold on
xlim=([-150 150]);
ylim=([-150 150]);
I = imread('map3.png'); 
h = image(xlim,-ylim,I); 
uistack(h,'bottom')

% Vehicle Model
x = [-1.666, -1.666, 1.666, 1.666];
y = [  0.754,  -0.754, -0.754, 0.754];
g = hgtransform;
myShape2 = patch('XData',x,'YData',y,'FaceColor','red','Parent',g);
set(myShape2,'Xdata',x,'Ydata',y);
%axis([-150 150 -150 150]); grid on;

[p_final,~] = size(out.state);
for k=1:20:(p_final-1)
    disp(k);
    pt1 = [out.state(k,1) out.state(k,2) 0];
    pt2 = [out.state(k+1,1) out.state(k+1,2) 0];
    r1 = out.state(k,3)*pi/180;
    r2 = out.state(k+1,3)*pi/180;
    g.Matrix = makehgtform('translate',pt1,'zrotate',r1);
    drawnow
end
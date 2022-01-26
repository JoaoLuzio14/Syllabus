clear; clc; close all; %maybe add a 31 node if we want movement 17->18

%plot the map
img = imread('mapa_4.png');
h = gca;
h.Visible = 'On';
imshow(img);
hold on;

disp('use the mouse to input via points for the reference trajectory');
disp('--button 3-- to end the input');
button = 1;
k = 1;
while button==1
    [xx(k),yy(k),button] = ginput(1);
    plot(xx(k),yy(k),'r+')
    k = k + 1;
end

%source nodes, target nodes, their names and weights(distance between them)
s = [1 2 3 4 4 5 6 6 7 8 9 9 10 10 11 12 13 14 15 16 17 18 19 20 21 22 22 23 24 25 26 27 28 29 30 30];
t = [4 1 2 5 18 6 7 9 8 3 10 6 11 9 12 13 14 9 16 19 16 17 20 21 22 23 24 29 25 26 27 28 29 30 11 10];
node_names = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16','17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30'};
weight = [66 7 7 7 7 7 7 100 7 66 7 100 7 7 66 7 7 73 50 59 63 7 59 7 7 32 7 49 7 5 7 42 7 50 7 10];
%creating graph

%nodes coordinates
x = [250 260 271 262 265 277 287 287 304 294 282 296 307 318 92 98 110 250 111 105 104 108 117 114 124 134 146 137 148 265];
y = [52 36 48 204 225 240 224 205 483 497 511 663 675 664 94 241 229 220 398 415 432 495 510 615 630 627 614 521 508 500];

%[X, map] = imread('mapa_4(nodes_pontos).png'); %get coordinates
%imtool(X, map);


index=0;
cte=100000;
dist1=0
for i=1:16
    index1 = sqrt((x(i)-xx(1))^2+(y(i)-yy(1))^2)
    dist1=(x(i)-xx(1))^2-(y(i)-yy(1))^2
    if index1<cte
        index=i
        value=index1;
        cte=index1;
        dist=dist1;
    end
end

disp(index)
disp(x(index)-xx(1))
disp(y(index)-yy(1))
disp(dist)
l_index = find(s==index)
if(size(l_index))==1
    x = [x(1:end), round(xx(1))]
    y = [y(1:end),round(yy(1))]
    s = [s(1:end),s(end)+1]
    t = [t(1:end),t(l_index)]
    %t(l_index) = s(end)
    node_names = [node_names(1:end),string(max(s))]
    weight = [weight(1:index),weight(index),weight(index+1:end)]
else
    x = [x(1:end), round(xx(1))]
    y = [y(1:end),round(yy(1))]
    l_index = find(t==index)
    s = [s(1:end),s(end)+1]
    t = [t(1:end),t(l_index)]
    %t(l_index) = s(end)
    node_names = [node_names(1:end),string(max(s))]
    weight = [weight(1:index),weight(index),weight(index+1:end)]
end

D = digraph(s, t, weight, node_names);

p = plot(D,'XData',x,'YData',y);
node_names(index+1)
shortPath = shortestpath(D,node_names(end), node_names(9)); %shortest path between nodes (n1 and n8 are chosen nodes)
highlight(p, shortPath, 'EdgeColor', 'r', 'LineWidth', 3);

%calculating the coordinates of the path
k=1;
res = zeros(1, 2);
for i = shortPath
    index = findnode(D, i);
    res(k, :) = [x(index), y(index)];
    k = k+1;
end


%%


out=sim('controller_v2',200);

figure()
img = imread('mapa_4.png');
h = gca;
h.Visible = 'On';
imshow(img);
hold on;

% x0=500;
% y0=20;
% width=292;
% height=586;
% figure()
% hold on
% ylim=([0 733]);
% xlim=([0 365]);
% I = imread('mapa_4.png'); 
% h = image(xlim,-ylim,I); 
% uistack(h,'bottom')
% set(gcf,'Position',[x0,y0,width,height])

x_scale = 0.41096;
disp(['xx scale factor ', num2str(x_scale), ' meters/pixel']);

y_scale = 0.40928;
disp(['yy scale factor ', num2str(y_scale), ' meters/pixel']);

% Vehicle Model
x = [-0.566, -0.566, 2.766, 2.766]./x_scale;
y = [  0.64,  -0.64, -0.64, 0.64]./y_scale;

g = hgtransform;
myShape2 = patch('XData',x,'YData',y,'FaceColor','red','Parent',g);
set(myShape2,'Xdata',x,'Ydata',y);
axis tight;


[p_final,~] = size(out.state);
for k=1:30:(p_final-1)
    disp(k);
    pt1 = [out.state(k,1) out.state(k,2) 0];
    r1 = round(out.state(k,3), 3);
    g.Matrix = makehgtform('translate',pt1,'zrotate',r1);
    drawnow
end

    
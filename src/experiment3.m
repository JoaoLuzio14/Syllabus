%scenario = drivingScenario;
%roadNetwork(scenario,'OpenStreetMap','tecnico.osm');
%plot(scenario)
clear; clc; close all;

%[X, map] = imread('tecnico_mapa.png');
%imtool(X, map);
img = imread('tecnico_mapa.png');
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

s = [1 3 3 4 2 5 6 6 7 8 9 10 11 11 12 13 14 15 16]; %source nodes
t = [3 5 10 2 1 7 7 8 15 9 7 16 12 13 6 14 12 4 11]; %target nodes
node_names = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16'};
weight = [73 13 68 73 10 100 10 74 100 10 74 76 10 48 59 10 48 13 40]; %distance between them


x = [221 246 237 266 251 258 288 278 306 32 43 77 53 90 260 42]; %nodes coordinates
y = [61 61 284 284 316 635 635 855 855 300 648 645 793 790 316 529]; %nodes coordinates

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
    t = [t(1:end),t(l_index)];
    t(l_index) = s(end)
    node_names = [node_names(1:end),string(max(s))]
    weight = [weight(1:index),weight(index),weight(index+1:end)]
else
    x = [x(1:end), round(xx(1))]
    y = [y(1:end),round(yy(1))]
    l_index = find(t==index)
    s = [s(1:end),s(end)+1]
    t = [t(1:end),t(l_index)];
    t(l_index) = s(end)
    node_names = [node_names(1:end),string(max(s))]
    weight = [weight(1:index),weight(index),weight(index+1:end)]
end

D = digraph(s, t, weight, node_names);

p = plot(D,'XData',x,'YData',y);
node_names(index+1)
shortPath = shortestpath(D,node_names(end), node_names(9)); %shortest path between nodes (n1 and n8 are chosen nodes)
highlight(p, shortPath, 'EdgeColor', 'r', 'LineWidth', 3);


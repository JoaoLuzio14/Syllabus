g%scenario = drivingScenario;
%roadNetwork(scenario,'OpenStreetMap','tecnico.osm');
%plot(scenario)
clear; clc; close all;

s = [1 3 3 4 5 6 6 7 8 9 10 11 11 12 13 14 15 16]; %source nodes
t = [3 5 10 2 7 7 8 15 9 7 16 12 13 6 14 12 4 11]; %target nodes
node_names = {'n1', 'n2', 'n3', 'n4', 'n5', 'n6', 'n7', 'n8', 'n9', 'n10', 'n11', 'n12', 'n13', 'n14', 'n15', 'n16'};
weight = [73 13 68 73 100 10 74 100 10 74 76 10 48 59 10 48 13 40]; %distance between them
D = digraph(s, t, weight, node_names);

x = [221 246 237 266 251 258 288 278 306 32 43 77 53 90 260 42]; %nodes coordinates
y = [61 61 284 284 316 635 635 855 855 300 648 645 793 790 316 529]; %nodes coordinates

%[X, map] = imread('tecnico_mapa.png');
%imtool(X, map);
img = imread('tecnico_mapa.png');
h = gca;
h.Visible = 'On';
imshow(img);
hold on;

p = plot(D,'XData',x,'YData',y);
shortPath = shortestpath(D, 'n1', 'n8'); %shortest path between nodes (n1 and n8 are chosen nodes)
highlight(p, shortPath, 'EdgeColor', 'r', 'LineWidth', 3);



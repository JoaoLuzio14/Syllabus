clear; clc; close all; %maybe add a 31 node if we want movement 17->18

%source nodes, target nodes, their names and weights(distance between them)
s = [1 2 3 4 4 5 6 6 7 8 9 9 10 10 11 12 13 14 15 16 17 18 19 20 21 22 22 23 24 25 26 27 28 29 30 30];
t = [4 1 2 5 18 6 7 9 8 3 10 6 11 9 12 13 14 9 16 19 16 17 20 21 22 23 24 29 25 26 27 28 29 30 11 10];
node_names = {'n1', 'n2', 'n3', 'n4', 'n5', 'n6', 'n7', 'n8', 'n9', 'n10', 'n11', 'n12', 'n13', 'n14', 'n15', 'n16','n17', 'n18', 'n19', 'n20', 'n21', 'n22', 'n23', 'n24', 'n25', 'n26', 'n27', 'n28', 'n29', 'n30'};
weight = [66 7 7 7 7 7 7 100 7 66 7 100 7 7 66 7 7 73 50 59 63 7 59 7 7 32 7 49 7 5 7 42 7 50 7 10];
%creating graph
D = digraph(s, t, weight, node_names);

%nodes coordinates
x = [250 260 271 262 265 277 287 287 304 294 282 296 307 318 92 98 110 250 111 105 104 108 117 114 124 134 146 137 148 265];
y = [52 36 48 204 225 240 224 205 483 497 511 663 675 664 94 241 229 220 398 415 432 495 510 615 630 627 614 521 508 500];

%[X, map] = imread('mapa_4(nodes_pontos).png'); %get coordinates
%imtool(X, map);

%plot the map
img = imread('mapa_4.png');
h = gca;
h.Visible = 'On';
imshow(img);
hold on;

%plot the graph on the map
p = plot(D,'XData',x,'YData',y);
%shortest path between nodes
shortPath = shortestpath(D, 'n1', 'n14');
highlight(p, shortPath, 'EdgeColor', 'r', 'LineWidth', 3);

%calculating the coordinates of the path
k=1;
res = zeros(1, 2);
for i = shortPath
    index = findnode(D, i);
    res(k, :) = [x(index), y(index)];
    k = k+1;
end

    



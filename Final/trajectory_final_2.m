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
xx=ones(2);
yy=ones(2);
while button==1
    [xx(k),yy(k),button] = ginput(1);
    plot(xx(k),yy(k),'r+')
    k = k + 1;
end

%source nodes, target nodes, their names and weights(distance between them)
s = [1 2 3 4 4 5 6 6 7 8 9 9 10 10 11 12 13 14 15 16 17 18 19 20 21 22 22 23 24 25 26 27 28 29 30 30];
t = [4 1 2 5 18 6 7 9 8 3 10 6 11 9 12 13 14 9 16 19 16 17 20 21 22 23 24 29 25 26 27 28 29 30 11 10];
node_names = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16','17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30'};
weight = [66 7 7 7 7 7 7 100 7 66 7 100 7 7 66 7 7 73 50 59 7 63 7 7 32 7 49 7 5 5 7 42 7 50 7 10];
%creating graph

%nodes coordinates
x = [250 260 271 262 266 278 287 287 306 294 282 296 308 319 92 98 110 254 111 105 104 108 117 114 124 137 145 138 147 271];
y = [52 36 48 204 222 242 220 205 488 497 509 668 677 668 94 241 229 219 398 415 432 495 509 615 627 627 614 517 507 499];

%[X, map] = imread('mapa_4(nodes_pontos).png'); %get coordinates
%imtool(X, map);

%%
max_s_inicial=max(s); %16
max_t_inicial=max(t); %16
length_x=length(x);
index1=ones(size(x));
dist1=ones(size(x));
index2=ones(size(x));
dist2=ones(size(x));


for i=1:length(x)
    index1(i) = sqrt((x(i)-xx(1))^2+(y(i)-yy(1))^2);
    dist1(i) = (x(i)-xx(1))^2-(y(i)-yy(1))^2;
    index2(i) = sqrt((x(i)-xx(2))^2+(y(i)-yy(2))^2);
    dist2(i) =(x(i)-xx(2))^2-(y(i)-yy(2))^2;
    disp(i)
end

%% ponto inicial, xx(1)
for j=1:(length_x-1)
    index1_sort=sort(index1)
    L=find(index1==index1_sort(1)); %L é o node mais próximo
    L2=find(index1==index1_sort(j+1)); %L2 é o seguinte node mais próximo
    
    %verifica se há caminho do s->t ou do t->s
    caminho_s_t=0;
    for i=1:length(s)
        if s(i)==L
            if t(i)==L2
                caminho_s_t=1;
            end
        end
    end
    
    caminho_t_s=0;
    for i=1:length(s)
        if t(i)==L
            if s(i)==L2
                caminho_t_s=1;
            end
        end
    end
    
    %ponto medio estrada
    cord_x=(x(L)+x(L2))./2;
    cord_y=(y(L)+y(L2))./2;
    %raio estrada
    tamanho_estrada = sqrt((x(L)-cord_x)^2+(y(L)-cord_y)^2);
    %distancia ponto inicial ao ponto médio
    dist_ponto_estrada = sqrt((xx(1)-cord_x)^2+(yy(1)-cord_y)^2);
    
    if(caminho_s_t==1)        
        if(dist_ponto_estrada<tamanho_estrada)
            %quer dizer que o ponto está na estrada, logo faz-se caminho
            %desde o ponto inicial até ao L2
            x = [x(1:end), round(xx(1))]
            y = [y(1:end),round(yy(1))]
            s = [s(1:end),s(end)+1]
            t = [t(1:end),L2]
            node_names = [node_names(1:end),string(max(s))]
            weight = [weight(1:end),dist_ponto_estrada]
            break;
        end
    else
        if(caminho_t_s==1)  
            if(dist_ponto_estrada<tamanho_estrada)
                %se sim, então há caminho entre o t e o s, pelo que é
                %adicionado o ponto ao final do s e no t coloca-se o s
                x = [x(1:end), round(xx(1))]
                y = [y(1:end),round(yy(1))]
                s = [s(1:end),s(end)+1]
                t = [t(1:end),L]
                node_names = [node_names(1:end),string(max(s))]
                weight = [weight(1:end),dist_ponto_estrada]
                break;
            end
        end
    end
end

if max(s)==max_s_inicial 
    %quer dizer que não se há caminho_s_t ou caminho_t_s==1, pelo que não
    %há dois nodes entre os pontos. desta forma, ele vai-se ligar 
    %simplesmente ao node mais próximo, L
    x = [x(1:end), round(xx(1))]
    y = [y(1:end),round(yy(1))]
    s = [s(1:end),s(end)+1]
    t = [t(1:end),L]
    node_names = [node_names(1:end),string(max(s))]
    weight = [weight(1:end),dist_ponto_estrada]    
end

%% ponto final, xx(2)

for j=1:(length_x-1)
    index2_sort=sort(index2)
    L=find(index2==index2_sort(1)) %L é o node mais próximo
    L2=find(index2==index2_sort(j+1)) %L2 é o seguinte node mais próximo
    
    %verifica se há caminho do s->t ou do t->s
    caminho_s_t=0; 
    for i=1:length(s)
        if s(i)==L %s=ponto mais proximo 
            if t(i)==L2
                caminho_s_t=1;
            end
        end
    end
    
    caminho_t_s=0;
    for i=1:length(s)
        if t(i)==L %t=ponto mais proximo 
            if s(i)==L2
                caminho_t_s=1;
            end
        end
    end
    
    %ponto medio estrada
    cord_x=(x(L)+x(L2))./2
    cord_y=(y(L)+y(L2))./2
    %raio estrada
    tamanho_estrada = sqrt((x(L)-cord_x)^2+(y(L)-cord_y)^2);
    %distancia ponto inicial ao ponto médio
    dist_ponto_estrada = sqrt((xx(2)-cord_x)^2+(yy(2)-cord_y)^2);
    
    if(caminho_s_t==1)        
        if(dist_ponto_estrada<tamanho_estrada)
            %quer dizer que o ponto está na estrada, logo faz-se caminho
            %desde o L até ao ponto
            x = [x(1:end), round(xx(2))]
            y = [y(1:end),round(yy(2))]
            s = [s(1:end),L]
            t = [t(1:end),max(s)+1]
            node_names = [node_names(1:end),string(max(t))]
            weight = [weight(1:end),dist_ponto_estrada]
            break;
        end
    else
        if(caminho_t_s==1)  
            if(dist_ponto_estrada<tamanho_estrada)
                %se sim, então há caminho entre o t e o s, pelo que é
                %adicionado o ponto ao final do s e no t coloca-se o s
                x = [x(1:end), round(xx(2))]
                y = [y(1:end),round(yy(2))]
                s = [s(1:end),L2]
                t = [t(1:end),max(s)+1]
                node_names = [node_names(1:end),string(max(t))]
                weight = [weight(1:end),dist_ponto_estrada]
                break;
            end
        end
    end
end

if max(t)==max_t_inicial
    %quer dizer que não se há caminho_s_t ou caminho_t_s==1, pelo que não
    %há dois nodes entre os pontos. desta forma, ele vai-se ligar 
    %simplesmente ao node mais próximo, L, fazendo um caminho de L para o
    %ponto
    x = [x(1:end), round(xx(2))]
    y = [y(1:end),round(yy(2))]
    s = [s(1:end),L]
    t = [t(1:end),max(s)+1]
    node_names = [node_names(1:end),string(max(t))]
    weight = [weight(1:end),dist_ponto_estrada]    
end

%%

D = digraph(s, t, weight, node_names);

p = plot(D,'XData',x,'YData',y);
shortPath = shortestpath(D,node_names(end-1), node_names(end)); %shortest path between nodes (n1 and n8 are chosen nodes)
highlight(p, shortPath, 'EdgeColor', 'r', 'LineWidth', 3);

%%
%calculating the coordinates of the path
k=1;
res = zeros(1, 2);
for i = shortPath
    index = findnode(D, i);
    res(k, :) = [x(index), y(index)];
    k = k+1;
end


%%

out=sim('controller_go',200);

figure()
img = imread('mapa_4.png');
h = gca;
h.Visible = 'On';
imshow(img);
hold on;

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
for k=1:2:(p_final-1)
    disp(k);
    pt1 = [out.state(k,1) out.state(k,2) 0];
    r1 = round(out.state(k,3), 3);
    g.Matrix = makehgtform('translate',pt1,'zrotate',r1);
    drawnow limitrate
end

    
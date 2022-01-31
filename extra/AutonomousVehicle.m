%% Autonomous Vehicle

% IST - Robotics - Lab 2

%   João Luzio  - 93096 - joaoluzio14@tecnico.ulisboa.pt
% Marcelo Forte - 93125 - marcelojsforte@tecnico.ulisboa.pt
% Filipe Ferraz - 93771 - filipe.ferraz@tecnico.ulisboa.pt

% In order to use optimization, installation of CVX software is required.
% http://cvxr.com/cvx/

%% Specify This parameters

B = 5*10^7; % Energy Budget
P0 = 200; % Idle Energy
MinimalEnergy = false; % true only if CVX software installed

%% Code Bengins 

load_system('controller');
if MinimalEnergy == false
    set_param('controller/Controller/ME', 'sw', '0');
    set_param('controller/Controller/DynamicVelocity/ME', 'sw', '1');
else
    set_param('controller/Controller/ME', 'sw', '1');
    set_param('controller/Controller/DynamicVelocity/ME', 'sw', '0');
end

%plot the map
img = imread('map.png');
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
s = [1 2 3 4 4 5 6 6 7 8 9 9 10 10 11 12 13 14 15 16 17 18 19 20 21 22 22 23 24 25 26 27 28 29 30 30 17 31 31 15 32 33 32 34 3 34 35 36];
t = [4 1 2 5 18 6 7 9 8 3 10 6 11 9 12 13 14 36 31 19 16 17 20 21 22 23 24 29 25 26 27 28 29 30 11 10 31 16 15 32 15 32 33 2 34 35 34 9];
node_names = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16','17', '18', ... 
    '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36'};
weight = [66 7 7 7 7 7 7 100 7 66 7 100 7 7 66 7 7 66 50 59 7 63 7 7 32 7 49 7 5 5 7 42 7 50 7 10 7 7 50 7 7 7 7 7 7 30 30 7];

%nodes coordinates
x = [251 261 272 262 266 278 287 287 306 294 282 296 308 319 90 100 110 253 112 108 104 108 118 114 124 137 145 138 147 271 98 73 48 282 346 309];
y = [48 38 47 206 222 242 220 205 488 497 509 668 677 668 64 241 229 217 398 412 426 499 508 615 627 627 614 517 507 499 219 44 40 36 28 509];



%%%%%
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
end

%%% ponto inicial, xx(1)
for j=1:(length_x-1)
    index1_sort=sort(index1)
    L_inicial=find(index1==index1_sort(1)) %L é o node mais próximo
    L2_inicial=find(index1==index1_sort(j+1)) %L2 é o seguinte node mais próximo
    
    %verifica se há caminho do s->t ou do t->s
    caminho_s_t=0;
    for i=1:length(s)
        if s(i)==L_inicial
            if t(i)==L2_inicial
                caminho_s_t=1
            end
        end
    end
    
    caminho_t_s=0;
    for i=1:length(s)
        if t(i)==L_inicial
            if s(i)==L2_inicial
                caminho_t_s=1
            end
        end
    end
    
    %ponto medio estrada
    cord_x=(x(L_inicial)+x(L2_inicial))./2;
    cord_y=(y(L_inicial)+y(L2_inicial))./2;
    %raio estrada
    tamanho_estrada = sqrt((x(L_inicial)-cord_x)^2+(y(L_inicial)-cord_y)^2);
    %distancia ponto inicial ao ponto médio
    dist_ponto_estrada = sqrt((xx(1)-cord_x)^2+(yy(1)-cord_y)^2);
    count=0;
    
    if(caminho_s_t==1)        
        disp('caminho_s_t')
        if(dist_ponto_estrada<tamanho_estrada)
            %quer dizer que o ponto está na estrada, logo faz-se caminho
            %desde o ponto inicial até ao L2
            x = [x(1:end), round(xx(1))]
            y = [y(1:end),round(yy(1))]
            s = [s(1:end),s(end)+1]
            t = [t(1:end),L2_inicial]
            dist=0.5*sqrt((xx(1)-x(L2_inicial))^2+(yy(1)-y(L2_inicial))^2);
            node_names = [node_names(1:end),string(max(s))]
            weight = [weight(1:end),dist];
            count=count+1
        end
    end
    
    if(caminho_t_s==1)
        disp('caminho_t_s')
        if(dist_ponto_estrada<tamanho_estrada)
            %se sim, então há caminho entre o t e o s, pelo que é
            %adicionado o ponto ao final do s e no t coloca-se o s
            x = [x(1:end), round(xx(1))]
            y = [y(1:end),round(yy(1))]
            s = [s(1:end),s(end)+1]
            t = [t(1:end),L_inicial]
            dist=0.5*sqrt((xx(1)-x(L_inicial))^2+(yy(1)-y(L_inicial))^2);
            node_names = [node_names(1:end),string(max(s))]
            weight = [weight(1:end),dist]
            %break;
            count=count+1
        end
    end
    
    if caminho_s_t==1 
        if caminho_t_s==1
            if(dist_ponto_estrada<tamanho_estrada)
                %está numa estrada de dois sentidos
                s = [s(1:end),s(end), s(end-1)]
                t = [t(1:end),s(end), s(end-1)]
                weight = [weight(1:end),0, 0]
            end
        end
    end
        
        
    if count~=0
        break;
    end
end

if caminho_s_t==0
    if caminho_t_s==0
        %quer dizer que não se há caminho_s_t ou caminho_t_s==1, pelo que não
        %há dois nodes entre os pontos. desta forma, ele vai-se ligar
        %simplesmente ao node mais próximo, L
        x = [x(1:end), round(xx(1))]
        y = [y(1:end),round(yy(1))]
        s = [s(1:end),s(end)+1]
        t = [t(1:end),L_inicial]
        dist=0.5*sqrt((xx(1)-x(L_inicial))^2+(yy(1)-y(L_inicial))^2);
        node_names = [node_names(1:end),string(max(s))]
        weight = [weight(1:end),dist]
    end
end
Ponto_inicial=max(s)

%%% ponto final, xx(2)
for j=1:(length_x-1)
    index2_sort=sort(index2)
    L_final=find(index2==index2_sort(1)) %L é o node mais próximo
    L2_final=find(index2==index2_sort(j+1)) %L2 é o seguinte node mais próximo
    smax=max(s);
    %verifica se há caminho do s->t ou do t->s
    caminho_s_t=0;
    for i=1:length(s)
        if s(i)==L_final
            if t(i)==L2_final
                caminho_s_t=1
            end
        end
    end
    
    caminho_t_s=0;
    for i=1:length(s)
        if t(i)==L_final
            if s(i)==L2_final
                caminho_t_s=1
            end
        end
    end
    
    %ponto medio estrada
    cord_x=(x(L_final)+x(L2_final))./2;
    cord_y=(y(L_final)+y(L2_final))./2;
    %raio estrada
    tamanho_estrada = sqrt((x(L_final)-cord_x)^2+(y(L_final)-cord_y)^2);
    %distancia ponto inicial ao ponto médio
    dist_ponto_estrada = sqrt((xx(2)-cord_x)^2+(yy(2)-cord_y)^2);
    count=0;
    
    if(caminho_s_t==1)        
        disp('caminho_s_t')
        if(dist_ponto_estrada<tamanho_estrada)
            %quer dizer que o ponto está na estrada, logo faz-se caminho
            %desde L até ao ponto inicial
            x = [x(1:end), round(xx(2))]
            y = [y(1:end),round(yy(2))]
            s = [s(1:end),L_final]
            t = [t(1:end),smax+1]
            dist=0.5*sqrt((x(L_final)-xx(2))^2+(y(L_final)-yy(2))^2);
            node_names = [node_names(1:end),string(max(t))]
            weight = [weight(1:end),dist]
            count=count+1
        end
    end
    
    if(caminho_t_s==1)
        disp('caminho_t_s')
        if(dist_ponto_estrada<tamanho_estrada)
            %se sim, então há caminho entre o t e o s, pelo que é
            %adicionado o ponto ao final do s e no t coloca-se o s
            x = [x(1:end), round(xx(2))]
            y = [y(1:end),round(yy(2))]
            s = [s(1:end),L2_final]
            cte=max(t)
            if max(s)>max(t)
                cte=max(s)
            end
            t = [t(1:end),cte+1]
            dist=0.5*sqrt((x(L2_final)-xx(2))^2+(y(L2_final)-yy(2))^2);
            node_names = [node_names(1:end),string(max(t))]
            weight = [weight(1:end),dist]
            %break;
            count=count+1
        end
    end
    
    if caminho_s_t==1
        if caminho_t_s==1
            if(dist_ponto_estrada<tamanho_estrada)
                %está numa estrada de dois sentidos, então vai ligar os
                %dois caminhos um ao outro
                s = [s(1:end),max(t), max(t-1)]
                t = [t(1:end),t(end-1), t(end)]
                weight = [weight(1:end),0, 0]
            end
        end
    end
        
        
    if count~=0
        break;
    end
end

if caminho_s_t==0
    if caminho_t_s==0
        %quer dizer que não se há caminho_s_t ou caminho_t_s==1, pelo que não
        %há dois nodes entre os pontos. desta forma, ele vai-se ligar
        %simplesmente ao node mais próximo, L, fazendo um caminho de L para o
    %ponto
        x = [x(1:end), round(xx(2))]
        y = [y(1:end),round(yy(2))]
        s = [s(1:end),L_final]
        t = [t(1:end),max(s)+1]
        dist=0.5*sqrt((x(L_final)-xx(2))^2+(y(L_final)-yy(2))^2);
        node_names = [node_names(1:end),string(max(t))]
        weight = [weight(1:end),dist]
    end
end
Ponto_final=max(t)


if L_inicial==L2_final
    if L2_inicial==L_final
        %quer dizer que se o ponto final e inicial se encontram na mesma
        %estrada, pelo que o caminho deve ser, simplesmente, do ponto
        %inicial para o ponto final
        s = [s(1:end),Ponto_inicial]
        t = [t(1:end),Ponto_final]
        weight = [weight(1:end),0]
    end
end

%%%

D = digraph(s, t, weight, node_names);

p = plot(D,'XData',x,'YData',y);
shortPath = shortestpath(D, Ponto_inicial, Ponto_final); %shortest path between nodes (n1 and n8 are chosen nodes)
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
disp('Determinando o caminho mais próximo...') 

% Compute minimal energy velocities
if MinimalEnergy == true
    [speed, E] = EnergyOpt(res, P0);
else
    [K,~] = size(res);
    speed = zeros(K-1,1);
end

% Run Simulation
out=sim('controller',300);

if out.energy > B
   fprintf("Energy budget is too low to ride along the chosen path...\n");
   return
else
   fprintf("Success! Initiating motion...\n");
end

figure()
img = imread('map.png');
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

fprintf("Total Energy Spent: %8.3f J\n", round(out.energy,3));
fprintf("Number of Collisions: ...\n");
clear;
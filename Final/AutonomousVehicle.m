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
lambda = 5; % Regularization Term
MinimalEnergy = false; % true if CVX software installed

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
s = [1 2 3 4 4 5 6 6 7 8 9 9 10 10 11 12 13 14 15 16 17 18 19 20 21 22 22 23 24 25 26 27 28 29 30 30 17 31 31 15 32 33 32 34 3 34 35 36 37 38 38 39];
t = [4 1 2 5 18 38 39 9 8 3 10 6 11 9 12 13 14 36 31 19 16 17 20 21 22 23 37 29 25 26 27 28 29 30 11 10 31 16 15 32 15 32 33 2 34 35 34 9 24 6 39 7];
node_names = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16','17', '18', ... 
    '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39'};
weight = [66 7 7 7 7 6 6 100 7 66 7 100 7 7 66 7 7 66 50 59 7 63 7 7 32 7 7 7 5 5 7 42 7 50 7 10 7 7 50 7 7 7 7 7 7 30 30 7 40 5 5 5];

%nodes coordinates
x = [251 261 272 262 266 279 287 287 306 294 283 296 308 319 90 100 110 253 112 108 104 108 118 114 124 137 145 138 147 271 98 73 48 282 346 309 109 271 283];
y = [48 38 47 206 222 249 220 205 488 497 508 668 677 668 64 241 229 217 398 412 426 499 508 615 627 627 614 517 507 499 219 44 40 36 28 509 521 234 234];


%%%%%
length_x=length(x);
index1=ones(size(x));
index2=ones(size(x));

for i=1:length(x)
    index1(i) = sqrt((x(i)-xx(1))^2+(y(i)-yy(1))^2);
    index2(i) = sqrt((x(i)-xx(2))^2+(y(i)-yy(2))^2);
end

%%% Adding inicial point, xx(1), to graph
for j=1:(length_x-1)
    index1_sort=sort(index1);
    L_initial=find(index1==index1_sort(1)); %L is the closest node
    L_next_initial=find(index1==index1_sort(j+1)); %L2 is the next closest node
    
    %Check if the is a path from 's' to 't' or from 't' to 's'
    path_s_t=0;
    for i=1:length(s)
        if s(i)==L_initial
            if t(i)==L_next_initial
                path_s_t=1;
            end
        end
    end
    
    path_t_s=0;
    for i=1:length(s)
        if t(i)==L_initial
            if s(i)==L_next_initial
                path_t_s=1;
            end
        end
    end
    
    %midpoint of the L-L_next road section
    cord_x=(x(L_initial)+x(L_next_initial))./2;
    cord_y=(y(L_initial)+y(L_next_initial))./2;
    
    %radius of the L-L_next road section
    road_radius = sqrt((x(L_initial)-cord_x)^2+(y(L_initial)-cord_y)^2);
    
    %distance from initial point to midpoint
    dist_point_road = sqrt((xx(1)-cord_x)^2+(yy(1)-cord_y)^2);
    count=0;
    
    if(path_s_t==1)        
        if(dist_point_road<road_radius)
            %it means that the point is on the road, so make a path from 
            %the initial point (node 40), to L_next
            x = [x(1:end), round(xx(1))];
            y = [y(1:end),round(yy(1))];
            s = [s(1:end),s(end)+1];
            t = [t(1:end),L_next_initial];
            dist=0.5*sqrt((xx(1)-x(L_next_initial))^2+(yy(1)-y(L_next_initial))^2);
            node_names = [node_names(1:end),string(max(s))];
            weight = [weight(1:end),dist];
            count=count+1;
        end
    end
    
    if(path_t_s==1)
        if(dist_point_road<road_radius)
            %if yes, then there is a path between the 't' and the 's', so 
            %make a path from the initial point to L
            x = [x(1:end), round(xx(1))];
            y = [y(1:end),round(yy(1))];
            s = [s(1:end),s(end)+1];
            t = [t(1:end),L_initial];
            dist=0.5*sqrt((xx(1)-x(L_initial))^2+(yy(1)-y(L_initial))^2);
            node_names = [node_names(1:end),string(max(s))];
            weight = [weight(1:end),dist];
            count=count+1;
        end
    end
    
    if path_s_t==1 
        if path_t_s==1
            if(dist_point_road<road_radius)
                %if yes, it means that the initial point is in a two way 
                %road, so make a path between the two initial nodes created 
                s = [s(1:end),s(end), s(end-1)];
                t = [t(1:end),s(end), s(end-1)];
                weight = [weight(1:end),0, 0];
            end
        end
    end
        
        
    if count~=0
        break;
    end
end

if path_s_t==0
    if path_t_s==0
        %that means there is no s_t path or t_s path, so there are no 
        %two nodes between the initial point. In this way, it will simply 
        %connect to the nearest node, L
        x = [x(1:end), round(xx(1))];
        y = [y(1:end),round(yy(1))];
        s = [s(1:end),s(end)+1];
        t = [t(1:end),L_initial];
        dist=0.5*sqrt((xx(1)-x(L_initial))^2+(yy(1)-y(L_initial))^2);
        node_names = [node_names(1:end),string(max(s))];
        weight = [weight(1:end),dist];
    end
end
initial_node=max(s);


%%% Final point, xx(2)
for j=1:(length_x-1)
    
    index2_sort=sort(index2);
    L_final=find(index2==index2_sort(1)); %L is the closest node
    L2_final=find(index2==index2_sort(j+1)); %L2 is the next closest node
    smax=max(s);
    
    %Check if the is a path from 's' to 't' or from 't' to 's'
    path_s_t=0;
    for i=1:length(s)
        if s(i)==L_final
            if t(i)==L2_final
                path_s_t=1;
            end
        end
    end
    
    path_t_s=0;
    for i=1:length(s)
        if t(i)==L_final
            if s(i)==L2_final
                path_t_s=1;
            end
        end
    end
    
    %midpoint of the L-L_next road section
    cord_x=(x(L_final)+x(L2_final))./2;
    cord_y=(y(L_final)+y(L2_final))./2;
    
    %radius of the L-L_next road section
    road_radius = sqrt((x(L_final)-cord_x)^2+(y(L_final)-cord_y)^2);
    
    %distance from final point, to midpoint
    dist_point_road = sqrt((xx(2)-cord_x)^2+(yy(2)-cord_y)^2);
    count=0;
    
    if(path_s_t==1)        
        if(dist_point_road<road_radius)
            %it means that the point is on the road, so make a path from 
            %the closest node, L_final, to the final point
            x = [x(1:end), round(xx(2))];
            y = [y(1:end),round(yy(2))];
            s = [s(1:end),L_final];
            t = [t(1:end),smax+1];
            dist=0.5*sqrt((x(L_final)-xx(2))^2+(y(L_final)-yy(2))^2);
            node_names = [node_names(1:end),string(max(t))];
            weight = [weight(1:end),dist];
            count=count+1;
        end
    end
    
    if(path_t_s==1)
        if(dist_point_road<road_radius)
            %if yes, then there is a path between the 't' and the 's', so 
            %make a path from L2_final to the final point 
            x = [x(1:end), round(xx(2))];
            y = [y(1:end),round(yy(2))];
            s = [s(1:end),L2_final];
            cte=max(t);
            
            if max(s)>max(t)
                cte=max(s);
            end
            
            t = [t(1:end),cte+1];
            dist=0.5*sqrt((x(L2_final)-xx(2))^2+(y(L2_final)-yy(2))^2);
            node_names = [node_names(1:end),string(max(t))];
            weight = [weight(1:end),dist];
            count=count+1;
        end
    end
    
    if path_s_t==1
        if path_t_s==1
            if(dist_point_road<road_radius)
                %if yes, it means that the initial point is in a two way 
                %road, so make a path between the two final nodes created 
                s = [s(1:end),max(t), max(t-1)];
                t = [t(1:end),t(end-1), t(end)];
                weight = [weight(1:end),0, 0];
            end
        end
    end
        
        
    if count~=0
        break;
    end
end

if path_s_t==0
    if path_t_s==0
        %that means there is no s_t path or t_s path, so there are no 
        %two nodes between the initial point. In this way, it will simply 
        %connect from the closest node to the final point
        x = [x(1:end), round(xx(2))];
        y = [y(1:end),round(yy(2))];
        s = [s(1:end),L_final];
        t = [t(1:end),max(s)+1];
        dist=0.5*sqrt((x(L_final)-xx(2))^2+(y(L_final)-yy(2))^2);
        node_names = [node_names(1:end),string(max(t))];
        weight = [weight(1:end),dist];
    end
end
final_node=max(t);


if L_initial==L2_final
    if L_next_initial==L_final
        if (path_s_t==1) && (path_t_s==1)
            %If the final point and initial point are on the same road 
            %section and this road is two-way, the path must simply be from 
            %the initial point to the final point.
            s = [s(1:end),initial_node];
            t = [t(1:end),final_node];
            weight = [weight(1:end),0];
        end
    end
end

%%%

D = digraph(s, t, weight, node_names);

p = plot(D,'XData',x,'YData',y);
shortPath = shortestpath(D, initial_node, final_node); %shortest path between nodes (n1 and n8 are chosen nodes)
highlight(p, shortPath, 'EdgeColor', 'r', 'LineWidth', 3);


%calculating the coordinates of the path
k=1;
res = zeros(1, 2);
for i = shortPath
    index = findnode(D, i);
    res(k, :) = [x(index), y(index)];
    k = k+1;
end
[res,ia,ic] = unique(res,'rows', 'stable');


%% Compute the Path

if (DetectCol(res(1,1),res(1,2)) == 1) || (DetectCol(res(end,1),res(end,2)) == 1)
    disp('Invalid start and/or end goal point! Abort.');
    return
end


disp('Finding the shortest path...');

% Compute minimal energy velocities
if MinimalEnergy == true
    [speed, E] = EnergyOpt(res, P0, lambda);
    colstep = 30000;
else
    [K,~] = size(res);
    speed = zeros(K-1,1);
    colstep = 5000;
end

% Run Simulation
out=sim('controller',1000);

if out.energy > B
   fprintf("Energy budget is too low to ride along the chosen path...\n");
   return
else
   fprintf("Success! Initiating motion...\n");
end

% Collision Count
counter = 0;
[p_final,~] = size(out.state);
t1 = atan(-0.64/0.566) + pi;
t2 = atan(0.64/2.766);
r1 = sqrt((0.5676)^2 + (0.64)^2);
r2 = sqrt((2.766)^2 + (0.64)^2);
for k=3000:800:(p_final-1000)
    pt = [out.state(k,1) out.state(k,2) out.state(k,3)];
    check = DetectCol(pt(1) + r2*cos(t2 + pt(3)), pt(2) + r2*sin(t2 + pt(3)));
    if check == 1
        counter = counter+1;
        k = k + colstep;
        continue;
    end
    check = DetectCol(pt(1) + r2*cos(-t2 + pt(3)), pt(2) + r2*sin(-t2 + pt(3)));
    if check == 1
        counter = counter+1;
        k = k + colstep;
        continue;
    end
    check = DetectCol(pt(1) + r1*cos(t1 + pt(3)), pt(2) + r1*sin(t1 + pt(3)));
    if check == 1
        counter = counter+1;
        k = k + colstep;
        continue;
    end
    check = DetectCol(pt(1) + r1*cos(-t1 + pt(3)), pt(2) + r1*sin(-t1 + pt(3)));
    if check == 1
        counter = counter+1;
        k = k + colstep;
        continue;
    end
end


% Plot Motion

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
    pt1 = [out.state(k,1) out.state(k,2) 0];
    r1 = round(out.state(k,3), 3);
    g.Matrix = makehgtform('translate',pt1,'zrotate',r1);
    drawnow limitrate
end

% Relevant Data
fprintf("\n\nThe vehicle has reached his destination.\n\n");
fprintf("Total Energy Spent: %8.3f J\n\n", round(out.energy,3));
fprintf("Total Time Spent: %8.3f s\n\n", round(out.tout(end),3));
fprintf("Number of Collisions: %d \n\n", counter);
clear;
clear; clc; close all;

figure()
img = imread('mapa_4.png');
h = gca;
h.Visible = 'On';
imshow(img);

x = 260; %x coordinate of the point that we want to check
y = 45; %y coordinate of the point that we want to check

%if TFin == 1 then its a forbidden region and it needs to break
%if TFin ~= 1 for all TFin's then region selected is not forbidden
%this break needs to be implemented where says "invalid place"
%all the plots can be commented

hold on;
x1 = [258 265 281 270 258];
y1 = [44 44 210 211 44];
polyin1 = polyshape(x1, y1);
TFin1 = isinterior(polyin1,x,y);
%plot(x,y,'r*')
if TFin1 == 1
    %invalid place;
end
plot(polyin1);

hold on;
x2 = [243 250 258 105 100 230 228 100 96 87 66 56 1 1 243];
y2 = [1 119 213 222 96 74 71 90 57 45 36 34 41 1 1];
polyin2 = polyshape(x2, y2);
TFin2 = isinterior(polyin2,x,y);
%plot(x,y,'r*')
if TFin2 == 1
    %invalid place;
end
plot(polyin2);

hold on;
x3 = [263 264 257 256 263];
y3 = [1 31 31 1 1];
polyin3 = polyshape(x3, y3);
TFin3 = isinterior(polyin3,x,y);
%plot(x,y,'r*')
if TFin3 == 1
    %invalid place;
end
plot(polyin3);

hold on;
x4 = [277 277 365 365 277];
y4 = [1 29 19 1 1];
polyin4 = polyshape(x4, y4);
TFin4 = isinterior(polyin4,x,y);
%plot(x,y,'r*')
if TFin4 == 1
    %invalid place;
end
plot(polyin4);

x5 = [365 279 294 285 314 325 365 365];
y5 = [33 43 222 247 489 669 667 33];
polyin5 = polyshape(x5, y5);
TFin5 = isinterior(polyin5,x,y);
%plot(x,y,'r*')
if TFin5 == 1
    %invalid place;
end
plot(polyin5);

x6 = [365 327 329 365 365];
y6 = [681 683 733 733 681];
polyin6 = polyshape(x6, y6);
TFin6 = isinterior(polyin6,x,y);
%plot(x,y,'r*')
if TFin6 == 1
    %invalid place;
end
plot(polyin6);

x7 = [313 306 310 316];
y7 = [684 684 733 733];
polyin7 = polyshape(x7, y7);
TFin7 = isinterior(polyin7,x,y);
%plot(x,y,'r*')
if TFin7 == 1
    %invalid place;
end
plot(polyin7);

x8 = [300 290 305 313];
y8 = [503 504 671 670];
polyin8 = polyshape(x8, y8);
TFin8 = isinterior(polyin8,x,y);
%plot(x,y,'r*')
if TFin8 == 1
    %invalid place;
end
plot(polyin8);

x9 = [131 138 123 116 131];
y9 = [515 620 621 516 515];
polyin9 = polyshape(x9, y9);
TFin9 = isinterior(polyin9,x,y);
%plot(x,y,'r*')
if TFin9 == 1
    %invalid place;
end
plot(polyin9);

x10 = [260 272 299 115 110 117 119 106];
y10 = [225 250 489 503 424 407 385 235];
polyin10 = polyshape(x10, y10);
TFin10 = isinterior(polyin10,x,y);
%plot(x,y,'r*')
if TFin10 == 1
    %invalid place;
end
plot(polyin10);

x11 = [297 276 145 152 147 115 109 96 103 105 105 104 92 84 80 76 67 55 1 1 297];
y11 = [733 505 514 624 633 635 628 425 410 401 389 374 232 62 56 53 49 47 54 733 733];
polyin11 = polyshape(x11, y11);
TFin11 = isinterior(polyin11,x,y);
%plot(x,y,'r*')
if TFin11 == 1
    %invalid place;
end
plot(polyin11);

x12 = [279 277 274 279];
y12 = [223 230 223 223];
polyin12 = polyshape(x12, y12);
TFin12 = isinterior(polyin12,x,y);
%plot(x,y,'r*')
if TFin12 == 1
    %invalid place;
end
plot(polyin12);



















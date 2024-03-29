% Pull in data
clear all; clc;
T = readtable('./Large PPM/9-15-2022-T1.csv');
T = rmmissing(T);
% T = T(200:end-200,:);
X = (T.X-min(T.X)).*1000;
Y = (T.Y-min(T.Y)).*1000;
Z = (T.Z-min(T.Z)).*1000;

T.X = X;
T.Y = Z;
T.Z = Y;

% Find best fit plane
[n,V,p] = plane_fit([T.X,T.Y,T.Z]);
a= n(1);
b = n(2);
c = n(3);
d = a*p(1)+b*p(2)+c*p(3);

% Set limits for fit plane
n = 5;
x = linspace(min(T.X),max(T.X),2);
y = linspace(min(T.Y),max(T.Y),2);
[X,Y] = meshgrid(x,y);

% Find the distance from the plane to each point
D = abs(a.*T.X+b.*T.Y+c.*T.Z-d)./sqrt(a^2+b^2+c^2);


%% Plot of just points

figure(1); clf; hold on;

axis equal
grid on
title("PL-PPM Opitrack Motion")
set(gca,'fontsize',16)

% Plot all points
xlabel("X (mm)");
ylabel("Y (mm)");
zlabel("Z (mm)");

% Plot all points
scatter3(T.X,T.Y,T.Z,'filled');
set(gcf,'color','w');

%% Create plot of best fit plane
figure(2); clf; hold on
    
axis equal
grid on
title("PL-PPM Opitrack Motion")
set(gca,'fontsize',16)

% Plot all points
xlabel("X (mm)");
ylabel("Y (mm)");
zlabel("Z (mm)");

% Plot all points
scatter3(T.X,T.Y,T.Z,'filled');

% Plot the plane of best fit
Z = (-(a.*X + b.*Y)+d)./c;
surf(X,Y,Z,'facecolor','blue','facealpha',0.2)
set(gcf,'color','w');

%% Create Colormap plot

figure(3); clf; hold on

axis equal
grid on
title("PL-PPM Error Analysis")
set(gca,'fontsize',16)

% Plot all points
xlabel("X (mm)");
ylabel("Y (mm)");
zlabel("Z (mm)");

% Plot all the points
scatter3(T.X,T.Y,T.Z,[],D,'filled');
hcb = colorbar;
clim([0 10])
hcb.Label.String = 'Error (mm)';
set(gcf,'color','w');

%% Create Error Histrogram Distribution
figure(4); clf; hold on
histogram(D)
title("Distribution of Error","FontSize",24)
xlabel("Error(mm)","FontSize",18)
ylabel("Count","FontSize",18)
set(gcf,'color','w');
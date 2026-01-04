% Resolution equation de Laplace
%
clear
close all
clc

%% Dimensions / maillage
dx = 1; % cm
dy = 1; % cm
Nx = 40;
Ny = 40;

%% Potentiels / sources
v0 = 0;
v1 = 100;
v2 = -100;


%% Initialisation de la matrice de calcul
V = zeros(Nx, Ny);

%% Conditions aux limites
V(1, :)   = v0;  % bord gauche
V(Nx, :)  = v0;  % bord droit
V(:, 1)   = v0;  % bord bas
V(:, Ny)  = v0;  % bord haut
%% Définition des conducteurs

% Conducteur 1
x1 = 8:34;
y1 = 26:28;
V(x1, y1) = v1;

% Conducteur 2
x2 = 20:21;
y2 = 5:23;
V(x2, y2) = v2;

% Equation de calcul
% i=1;j=1;
% V(i,j)=1/4*(V(i+1,j)+V(i-1,j)+V(i,j+1)+V(i,j-1)); %methode des differences finies


%% Figure
figure;
pcolor(V');
colorbar;
colormap jet;
title(['TP02 — Potentiel après ', num2str(Niter), ' itérations']);
xlabel('x (i)');
ylabel('y (j)');
axis equal;


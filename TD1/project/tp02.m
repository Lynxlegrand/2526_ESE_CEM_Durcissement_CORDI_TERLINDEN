% TP02 — Résolution de l'équation de Laplace (200 itérations)
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

%% Boucle de calcul (200 itérations)
Niter = 10000;

for k = 1:Niter
    Vn = V;
    for i = 2:(Nx-1)
        for j = 2:(Ny-1)
            % Ne pas modifier les conducteurs
            if (any(i == x1) && any(j == y1)) || (any(i == x2) && any(j == y2))
                continue;
            end
            % Calcul de la nouvelle valeur (moyenne des 4 voisins)
            Vn(i,j) = 0.25 * (V(i+1,j) + V(i-1,j) + V(i,j+1) + V(i,j-1));
        end
    end

    V = Vn;


end


%% Figure
figure;
pcolor(V');
colorbar;
colormap jet;
title(['TP02 — Potentiel après ', num2str(Niter), ' itérations']);
xlabel('x (i)');
ylabel('y (j)');
axis equal;

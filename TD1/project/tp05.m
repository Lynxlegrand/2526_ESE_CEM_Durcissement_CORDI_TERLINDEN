% TP02 — Résolution de l'équation de Laplace avec test de convergence
clear
close all
clc

%% Dimensions / maillage
d = 0;
dx = 1; % cm
dy = 1; % cm
Nx = 40 + d;
Ny = 40 + d;

%% Potentiels / sources
v0 = 0;
v1 = 100;
v2 = -100;

%% Initialisation de la matrice de calcul
V = zeros(Nx, Ny);

%% Définition des conducteurs
x1 = 8:34;
y1 = 26:28;
V(x1, y1) = v1;

x2 = 20:21;
y2 = 5:23;
V(x2, y2) = v2;

%% Conditions aux limites
V(1, :)   = v0;  % bord gauche
V(Nx, :)  = v0;  % bord droit
V(:, 1)   = v0;  % bord bas
V(:, Ny)  = v0;  % bord haut

%% Boucle de calcul
Niter = 5000;       % max d'itérations
tol   = 1e-2;        % tolérance de convergence
diffmax = Inf;       % initialisation

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

##    % Réaffecter les conducteurs
##    Vn(x1, y1) = v1;
##    Vn(x2, y2) = v2;

    % Calcul de la différence maximale
    diffmax = max(max(abs(Vn - V)));

    % Mise à jour
    V = Vn;

    % Test de convergence
    if diffmax < tol
        fprintf('Convergence atteinte après %d itérations (différence max = %.6f)\n', k, diffmax);
        break;
    end
end

%% Affichage du résultat
figure;
pcolor(V');
colorbar;
colormap jet;
title(['Potentiel après ', num2str(k), ' itérations pour une tolerance de ', num2str(tol, '%.3g'), ' V']);
xlabel('x (i)');
ylabel('y (j)');
axis equal;

figure;
contour(V', 20, 'LineWidth', 1.5);  % 20 lignes équipotentielles
colorbar;
colormap jet;
title(['Lignes équipotentielles après ', num2str(k), ' itérations']);
xlabel('x (i)');
ylabel('y (j)');
axis equal tight;

figure;
pcolor(V');
shading interp;
hold on;
contour(V', 20, 'k');   % lignes noires par-dessus la carte de potentiel
colorbar;
colormap jet;
title(['Potentiel + Lignes équipotentielles (', num2str(k), ' itérations)']);
xlabel('x (i)');
ylabel('y (j)');
axis equal tight;

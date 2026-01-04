%%%%%%%%%%%%%%%%%
% Fonction FDTD
%%%%%%%%%%%%%%%%%

clear all
close all
clc

max_time  = 100;
max_space = 201;

% --- Constantes physiques ---
eps0 = 8.8542e-12;
mu0  = 4*pi*1e-7;
Z0   = 120*pi;

% --- Discretisation ---
L = 4;
dz = L./(max_space-1);
alpha = 1;
dt = alpha*sqrt(eps0*mu0)*dz;

alphaE = 1/eps0 * dt/dz;
alphaH = 1/mu0 * dt/dz;

% --- Initialisation des champs ---
E = zeros(max_space,1);
H = zeros(max_space-1,1);

% --- Paramètres de la source ---
spread = 1.6e-10;
center_problem_space = round(max_space/2);
t0 = 40*dt;

% ============================
%    BOUCLE TEMPORELLE
% ============================
for n = 1:max_time

    t = n*dt;

    % ----- Boucle sur E -----
    for k = 2:max_space-1
        E(k) = E(k) + alphaE * (H(k-1) - H(k));
    end

    % ----- Hard source -----
    pulse = exp( - ((t - t0)/spread)^2 );
    E(center_problem_space) = pulse;

    % ----- Boucle sur H -----
    for j = 1:max_space-1
        H(j) = H(j) + alphaH * (E(j) - E(j+1));
    end

    % ----- Affichage -----
    figure(1)
    plot([0:max_space-1]*dz , E)
    axis([0 (max_space)*dz -1.1 1.1])
    title('Simulation FDTD du champ electrique')
    xlabel('z (position) [m]')
    ylabel('E_x [V/m]')
    pause(0.05)

end % boucle temporelle

% ============================
%   Figures finales
% ============================
figure(2)
subplot(2,1,1)
plot([0.5:max_space-1.5]*dz, H,'r')
title(['Champ H_y à t=' num2str(n*dt*1e9) ' ns'])
ylabel('H_y [A/m]')
xlabel('z [m]')
axis([0 (max_space)*dz -1.1/Z0 1.1/Z0])

subplot(2,1,2)
plot([0:max_space-1]*dz, E,'g')
title(['Champ E_x à t=' num2str(n*dt*1e9) ' ns'])
ylabel('E_x [V/m]')
xlabel('z [m]')
axis([0 (max_space)*dz -1.1 1.1])


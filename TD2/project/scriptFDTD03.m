%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  scriptFDTD03.m
%  Source spatiale + amplitude corrigée
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

max_time  = 300;
max_space = 201;

% --- Constantes physiques ---
eps0 = 8.8542e-12;
mu0  = 4*pi*1e-7;
Z0   = 120*pi;
c0   = 1/sqrt(eps0*mu0);

% --- Discretisation ---
L = 4;                         % Longueur du domaine (m)
dz = L./(max_space-1);
alpha = 1;                     % Critère de stabilité (FDTD)
dt = alpha*sqrt(eps0*mu0)*dz;  % Pas temporel

alphaE = 1/eps0 * dt/dz;
alphaH = 1/mu0 * dt/dz;

% --- Initialisation des champs ---
E = zeros(max_space,1);
H = zeros(max_space-1,1);

% =============================
%     Source spatiale (au temps n=1 uniquement)
% =============================
spread = 1.6e-10;
z0 = L/2;                                  % Position de la source au centre

for k = 2:max_space-1
    z = (k-1)*dz;
    % Amplitude multipliée par 2 pour retrouver ondes d’amplitude 1
    E(k) = 2 * exp( - ((z - z0)/(c0*spread))^2 );
end

% =============================
%      BOUCLE TEMPORELLE
% =============================
for n = 1:max_time

    % ----- Boucle sur E -----
    for k = 2:max_space-1
        E(k) = E(k) + alphaE * (H(k-1) - H(k));
    end

    % (Pas de source ici, elle a été imposée uniquement à n=1)

    % ----- Boucle sur H -----
    for j = 1:max_space-1
        H(j) = H(j) + alphaH * (E(j) - E(j+1));
    end

    % ----- Affichage -----
    figure(1)
    plot([0:max_space-1]*dz , E)
    axis([0 (max_space)*dz -1.1 1.1])
    title('Simulation FDTD du champ électrique (source spatiale)')
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


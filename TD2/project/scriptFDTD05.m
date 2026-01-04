%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  scriptFDTD05.m
%  Propagation dans l'air avec conditions absorbantes + source en z=0.001
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

max_time  = 1500;

% --- Constantes physiques ---
eps0 = 8.8542e-12;
mu0  = 4*pi*1e-7;
Z0   = 120*pi;
c0   = 1/sqrt(eps0*mu0);

% --- Domaine et discrimination ---
L = 0.5;                     % longueur du domaine = 0,5 m
dz = 0.001;                  % pas spatial imposé
max_space = round(L/dz)+1;   % nombre de points total

alpha = 0.5;                 % critère de stabilité magique
dt = alpha * dz/c0;          % dt magique

alphaE = 1/eps0 * dt/dz;
alphaH = 1/mu0 * dt/dz;

% --- Initialisation des champs ---
E = zeros(max_space,1);
H = zeros(max_space-1,1);

% =============================
%   Source au point z = 0.001 => E(2)
% =============================
spread = 1.6e-10;
t0 = 400*dt;  % moment de maximum d'excitation temporelle

% =============================
%   Magic Time Step variables
% =============================
Eleft1=0; Eleft2=0;
Eright1=0; Eright2=0;

% =============================
%         BOUCLE TEMPORELLE
% =============================
for n = 1:max_time

    t = n*dt;

    % ----- Boucle sur E -----
    for k = 2:max_space-1
        E(k) = E(k) + alphaE * (H(k-1) - H(k));
    end

    % ----- Source gaussienne (excitation en E(2) uniquement) -----
    pulse = exp( - ((t - t0)/spread)^2 );
    E(2) = E(2) + pulse;     % soft source

    % ===== Magic Time Step =====
    % Bord gauche
    E(1) = Eleft2;
    Eleft2 = Eleft1;
    Eleft1 = E(2);

    % Bord droit
    E(max_space) = Eright2;
    Eright2 = Eright1;
    Eright1 = E(max_space-1);

    % ----- Boucle sur H -----
    for j = 1:max_space-1
        H(j) = H(j) + alphaH * (E(j) - E(j+1));
    end

    % ----- Affichage -----
    if mod(n,20)==0
        figure(1)
        plot([0:max_space-1]*dz , E)
        axis([0 L -1.1 1.1])
        title(['Propagation avec conditions absorbantes   t = ' num2str(t*1e9,'%.1f') ' ns'])
        xlabel('z (m)'), ylabel('E_x (V/m)')
        pause(0.01)
    end

end % boucle temporelle


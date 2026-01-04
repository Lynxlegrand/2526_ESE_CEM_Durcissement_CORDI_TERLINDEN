%%%%%%%%%%%%%%%%%
% Fonction FDTD
%%%%%%%%%%%%%%%%%
%function [] = foncFDTD02(time)
clear all
close all
clc

max_time  = 300;
max_space = 201;
alpha       = 0.5;

% Definition des constantes
eps0 = 8.8542e-12;
mu0  = 4*pi*1e-7;
Z0   = 120*pi;
c0   = 1/sqrt(eps0*mu0);

% Definition des discretisations
L = 2;                   % longueur du domaine
dz = L./(max_space-1);   % pas spatial
dt = alpha*sqrt(eps0*mu0).*dz;
%dt = 3.2e-11;
alphaE = 1./eps0 .* dt./dz;
alphaH = 1./mu0 .* dt./dz;

% Initialisation des champs E et H
% dimension en H = dimension en E - 1 du au schema
% conditions aux limites imposees ici pour E(1) et E(max_space)
E = zeros(max_space,1);
H = zeros(max_space-1,1);

% Largeur du pulse de la source
%spread = 12;
spread=1.6e-10;
% Centre du pulse
center_problem_space = round(max_space/2);   % spatial : au centre
t0 = 40*dt;               % source en temps maximale a cet instant

% Remarque : E est 1/2 pas de temps derriere
% car le pulse est introduit dans le probleme
% entre les boucles sur E et H
%
% Boucle exterieure temporelle

tmp11=0;
tmp12=0;
tmp21=0;
tmp22=0;

for n = 1:max_time


    % onde qui se deplace
    % for k = 1:max_space
    %     E(k)= exp(-((k - n)*dz/(c0*spread))^2);
    % end
    % Boucle interieure sur le champ E
    for k= 2:max_space-1
        E(k) = E(k) + alphaE * (H(k) - H(k-1));
    end
    % absorbtion aux bords

    E(1) = tmp12; %cote gauche
    tmp12 = tmp11;
    tmp11 = E(2);


    E(max_space) = tmp22; %cote droit
    tmp22 = tmp21;
    tmp21 = E(max_space-1);


    % Hard source
    pulse = exp(-((n*dt - t0)/spread)^2);% On double l'amplitude de la source pour doubler l'énergie du signal
    E(center_problem_space) += pulse;

    % Boucle interieure sur le champ H
    for j= 1:max_space-1
        H(j) = H(j) + alphaH * (E(j+1) - E(j));
    end
    % Trace et progression de l'onde electrique
    figure(1)
    plot([0:max_space-1]*dz,E)
    axis([0 (max_space)*dz -1.1 1.1])
    % Legendes et titre pour la figure
    title('Simulation FDTD du champ electrique')
    xlabel('z (position en espace) [m]')
    ylabel('E_x [V/m]')
    pause(0.01)
end % Fin de la boucle temporelle

% Traces des champs electrique et magnetique au temp maximum
figure(2)
subplot(2,1,1)
plot([0.5:max_space-1.5]*dz,H,'r')
title(['Simulation du champ magnetique a t=' num2str(n*dt*1e9) 'ns'])
ylabel('H_y [A/m]')
xlabel('z (position en espace) [m]')
axis([0*dz (max_space)*dz -1.1./Z0 1.1./Z0])
subplot(2,1,2)
plot([0:max_space-1]*dz,E,'g')
title(['Simulation du champ electrique a t=' num2str(n*dt*1e9) 'ns'])
ylabel('E_x [V/m]')
xlabel('z (position en espace) [m]')
axis([0*dz (max_space)*dz -1.1 1.1])


%end % Fin de la fonction

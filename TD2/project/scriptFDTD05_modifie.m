%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  scriptFDTD05.m
%  Propagation dans l'air et dans un slab diélectrique avec conditions absorbantes
%  + mesure des coefficients R et T
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

max_time  = 1500;

% --- Constantes physiques ---
eps0 = 8.8542e-12;
mu0  = 4*pi*1e-7;
Z0_vide = 120*pi;           % Impédance du vide

c0   = 1/sqrt(eps0*mu0);

% --- Domaine et discrétisation ---
L = 0.5;                     % longueur du domaine = 0.5 m
dz = 0.001;                  % pas spatial
max_space = round(L/dz)+1;   % nombre de points total

alpha = 0.5;                 % critère de stabilité magique
dt = alpha * dz/c0;          % dt magique

alphaE = 1/eps0 * dt/dz;
alphaH = 1/mu0 * dt/dz;

% --- Paramètres diélectrique ---
epsr_air = 1;
epsr_dielec = 4;

% Position du slab diélectrique dans le domaine
dielec_deb = round(0.2/dz);  % début à 0.2 m
dielec_fin = round(0.3/dz);  % fin à 0.3 m

% --- Initialisation des champs ---
E = zeros(max_space,1);
H = zeros(max_space-1,1);

% --- Calcul de alphaE spatialement variable ---
alphaEdielec = zeros(max_space,1);
for u = 1:max_space
    if (u >= dielec_deb && u <= dielec_fin)
        alphaEdielec(u) = alphaE / epsr_dielec;  % slab diélectrique
    else
        alphaEdielec(u) = alphaE / epsr_air;     % vide
    end
end

% --- Source ---
spread = 1.6e-10;
t0 = 400*dt;  % moment de maximum d'excitation temporelle

% --- Magic Time Step variables ---
Eleft1=0; Eleft2=0;
Eright1=0; Eright2=0;

% --- Vecteur spatial ---
z = (0:max_space-1)*dz;

% --- Itérations choisies pour snapshot et mesure ---
snapshots = [600, 800, 1000, 1200, 1400];

% Stockage snapshots pour affichage et analyse
snapCount = 0;
E_snaps = zeros(max_space,length(snapshots));

for n = 1:max_time

    t = n*dt;

    % --- Mise à jour E ---
    for k = 2:max_space-1
        E(k) = E(k) + alphaEdielec(k) * (H(k-1) - H(k));
    end

    % --- Source gaussienne ---
    pulse = exp( - ((t - t0)/spread)^2 );
    E(2) = E(2) + pulse;

    % --- Magic Time Step ---
    E(1) = Eleft2;
    Eleft2 = Eleft1;
    Eleft1 = E(2);

    E(max_space) = Eright2;
    Eright2 = Eright1;
    Eright1 = E(max_space-1);

    % --- Mise à jour H ---
    for j = 1:max_space-1
        H(j) = H(j) + alphaH * (E(j) - E(j+1));
    end

    % --- Sauvegarde des snapshots ---
    if ismember(n, snapshots)
        snapCount = snapCount + 1;
        E_snaps(:, snapCount) = E;
    end

    % --- Affichage temps réel ---
    if mod(n,50)==0
        figure(1);
        plot(z, E);
        axis([0 L -1.1 1.1]);
        title(['Propagation avec slab diélectrique   t = ' num2str(t*1e9,'%.1f') ' ns']);
        xlabel('z (m)'); ylabel('E_x (V/m)');
        hold on;
        fill([dielec_deb*dz dielec_fin*dz dielec_fin*dz dielec_deb*dz], [-1.1 -1.1 1.1 1.1], ...
             [0.8 0.8 0.8], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
        hold off;
        drawnow;
    end

end % boucle temporelle

% --- Choix du snapshot d'analyse (par exemple n=1200) ---
idx_snap = find(snapshots == 1200);
E_snap2 = E_snaps(:, idx_snap);

% --- Calcul théorique ---
Z0 = Z0_vide / sqrt(epsr_air);
Z1 = Z0_vide / sqrt(epsr_dielec);
R_th = (Z1 - Z0)/(Z1 + Z0);
T_th = 2*Z1/(Z1 + Z0);

fprintf('Coefficient réflexion théorique R = %.4f\n', R_th);
fprintf('Coefficient transmission théorique T = %.4f\n\n', T_th);

% --- Extraction zones pour mesure ---
idx_ref = find(z >= 0.009 & z <= 0.011);
idx_trans = find(z >= 0.248 & z <= 0.252);

% --- Mesure amplitudes (valeurs absolues car déphasage sur réflexion) ---
amp_reflechie = max(abs(E_snap2(idx_ref)));
amp_transmise = max(abs(E_snap2(idx_trans)));

fprintf('Amplitude onde réfléchie mesurée : %.3f (théorique ~%.3f)\n', amp_reflechie, abs(R_th));
fprintf('Amplitude onde transmise mesurée : %.3f (théorique ~%.3f)\n', amp_transmise, abs(T_th));

% --- Figures zooms ---

% Zoom onde réfléchie
figure(4); clf; hold on;
plot(z(idx_ref), E_snap2(idx_ref), 'b', 'LineWidth', 1.3);
grid on;
title(['Zoom onde réfléchie (n=' num2str(1200) ')']);
xlabel('z (m)');
ylabel('E_x (V/m)');
set(gca, 'FontSize', 12);

% Zoom onde transmise
figure(5); clf; hold on;
plot(z(idx_trans), E_snap2(idx_trans), 'b', 'LineWidth', 1.3);
grid on;
title(['Zoom onde transmise (n=' num2str(1200) ')']);
xlabel('z (m)');
ylabel('E_x (V/m)');
set(gca, 'FontSize', 12);


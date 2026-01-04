%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   coefRT.m
%   Calcul des coefficients R et T
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

% --- Constantes physiques ---
eps0 = 8.8542e-12;
mu0  = 4*pi*1e-7;

% --- Permittivités relatives (modifier si besoin) ---
epsr0 = 1;   % Vide
epsr1 = 4;   % Diélectrique

% --- Calcul des impédances ---
Z0 = sqrt(mu0/(eps0*epsr0));  % Impédance milieu 0
Z1 = sqrt(mu0/(eps0*epsr1));  % Impédance milieu 1

% --- Coefficients ---
R = (Z1 - Z0)/(Z1 + Z0);      % Coefficient de réflexion
T = (2*Z1)/(Z1 + Z0);         % Coefficient de transmission

% --- Affichage ---
fprintf('\n===== Coefficients de réflexion et transmission =====\n');
fprintf('Coefficient de réflexion R = %.3f \n', R);
fprintf('Coefficient de transmission T = %.3f \n\n', T);


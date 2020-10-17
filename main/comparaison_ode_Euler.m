% On nettoie l'espace de travail
clc;clear all;close all;

% Ajustement de paramètres quant à l'affichage des graphiques
screensize = get( groot, 'Screensize' );
pourcentage=80;
Position=[(100-pourcentage)/100*screensize(3:4)/2 screensize(3:4)*pourcentage/100];
set(0,'defaultFigurePosition',Position)
set(0,'defaultfigurecolor',[1 1 1])
set(0,'defaultaxesfontsize',17);
set(0,'defaultaxeslinewidth',2);
set(0,'defaultlinelinewidth',2);

%Initialisation des données
V_0 = -1.5;
n_0 = 0.5;
t_simu = 100;
i = 1;
dt = 0.1;

% Utilisation de la fonction ode
[T1, V_n1] = ode(V_0, n_0, t_simu, i);

% Utilisation Euler explicite 
[T2, V_n2] = intermediaire(V_0, n_0, i, t_simu, dt);

%Les graphiques relatifs à ode seront en noir, ceux relatifs à Euler en
%rouge
color = {'k', 'r'};

%Affichage des 2 graphiques de V(t)
subplot(1, 2, 1)
plot(T1, V_n1(:, 1), color{1});
hold on;
xlabel('temps t (ms)')
ylabel('V (/)')
title('V(t) - ode45 (noir) - Euler (rouge)')
%subplot(1, 2, 1)
plot(T2, V_n2(:, 1), color{2});
xlabel('temps t (ms)')
ylabel('V (/)')

%Affichage des 2 graphiques de n(t)
subplot(1, 2, 2)
plot(T1, V_n1(:, 2), color{1});
 hold on;
xlabel('temps t (ms)')
ylabel('n (/)')
title('n(t) - ode45 (noir) - Euler (rouge)')
subplot(1, 2, 2)
plot(T2, V_n2(:, 2), color{2});
xlabel('temps t (ms)')
ylabel('n (/)')

hold off;
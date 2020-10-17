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

%Initialisation selon les données de la question 4.1
V_initial = -1.5;
n_initial = 0.5;
duree = 20;
periode = 100;
I = [0 , 0.6 , 0.75 , 1.2, 0, 0.9 0 0 0 0];

%Sur base de ces données, utilisation de la fonction
%creation_vecteurs_I_app pour rendre les vecteurs "fonctionnels"
[ I_app, temps_I_app ] = creation_vecteurs_I_app(duree, periode, I);

%Définition de la tolérance relative et absolue (cfr. idem Question 2.3)
%options = odeset('RelTol', 1e-7, 'AbsTol', [1e-7, 1e-4]);
    
%Fonction ode45 en tant que telle
%[T, V_n] = ode45(@(temps, etats)nagumo(temps, etats, I_app, temps_I_app), [0; temps_I_app(end)], [V_initial; n_initial], options);
[T, V_n] = intermediaire(-1.5, 0.5, I_app, temps_I_app, 0.05);
%Affichage des graphiques
subplot(1, 2, 1)
plot(T, V_n(:,1));
xlabel('temps t (ms)')
ylabel('V (/)')
grid
title('ode45 : V(t)')

subplot(1, 2, 2)
plot(temps_I_app, I_app)
axis([0 length(I)*periode min(I)-0.4 max(I)+0.4])
title('Courant d''entrée constant par morceaux')
xlabel('temps t (ms)')
ylabel('intensité I (/)')


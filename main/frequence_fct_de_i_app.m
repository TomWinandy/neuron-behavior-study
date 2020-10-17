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

%Initialisation d'un compteur et de vecteurs colonnes remplis de 0
j=1;
Intensite = zeros(4000, 1);
simu = zeros(4000, 1);

%On boucle sur des valeurs d'intensité et pour chacune d'entre elle on
%calcule la fréquence des spikes produits
for i=0.001:0.001:4
    Intensite(j) = i;
    simu(j) = simulation_neurone(i);
    j =j+1;
    i
end

%Affichage du graphique
plot(Intensite, simu);
title('Fréquence de production de spikes en fonction du Iapp');
ylabel('fréquence f (Hz)');
xlabel('intensité I (/)');

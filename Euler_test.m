% On nettoie l'espace de travail
clc;clear all;close all;

% Ajustement de param�tres quant � l'affichage des graphiques
screensize = get( groot, 'Screensize' );
pourcentage=80;
Position=[(100-pourcentage)/100*screensize(3:4)/2 screensize(3:4)*pourcentage/100];
set(0,'defaultFigurePosition',Position)
set(0,'defaultfigurecolor',[1 1 1])
set(0,'defaultaxesfontsize',17);
set(0,'defaultaxeslinewidth',2);
set(0,'defaultlinelinewidth',2);

%Initialisation d'un compteur
j = 1;

%Initialisation des donn�es
V_init = -1.5;
n_init = 0.5;
intensite = 0.1;
temps_simu = 11.5;

%Cr�ation d'un tableau faisant r�f�rence aux diff�rentes couleurs
color = {'k', 'r', 'y', 'b', 'c', 'g', 'm'};

%Initialisation de legend_str, string pour acceuillir la l�gende
legend_str = cell(1, length(color));

hold on;

%Affichage des 5 courbes
%NB: intermediaire n'est qu'un simple copi�-coll� d'Euler_explicite mais
%sous forme d'une fonction prenant en entr�e un pas de temps et renvoyant
%le vecteur de temps et le vecteur de deux colonnes contenant V et n
for i=0.05:0.15:0.95
    [T, V_n] = intermediaire(V_init, n_init, intensite, temps_simu, i);
    plot(T, V_n(:,1), color{j});
    %Cr�ation d'un vecteur contenant les l�gendes de chaque courbe
    %NB : num2string converti un num�ro en string
    legend_str{j}=['Pas de temps: ' num2str(i)];
    j=j+1;
end 

%Affichage titre, l�gende et variables
legend(legend_str);
ylabel('V (/)')
xlabel('temps t (ms)')
grid
title('La m�thode d''Euler explicite est tr�s peu fiable pour des pas trop grands...');
hold off;
    
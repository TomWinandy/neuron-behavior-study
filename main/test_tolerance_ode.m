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

%Initialisation de vecteurs colonnes � 0
temps = zeros(10,1);
tolerance = zeros(10,1);

%Initialisation d'une tol�rance et d'un compteur
i= 1e-1;
j = 1 ; 

%Initialisation des autres donn�es
V_initial = -1.5;
n_initial = 0.5;
I = 1; 
t_simulation = 100 ;
I_app = [I; I];
temps_I_app = [0; t_simulation];


%On boucle en r�duisant � chaque fois la tol�rance exig�e
while i >= 1e-11 
    %D�finition de la tol�rance relative et absolue
    options = odeset('RelTol', i, 'AbsTol', [i, 1e-4]);
    
    %�valuation du temps d'ex�cution
    tic ;
    
    %Fonction ode45 en tant que telle (cfr. ode) sans assigner les valeurs
    [ ~ , ~] = ode45(@(temps, etats)nagumo(temps, etats, I_app, temps_I_app), [0; t_simulation], [V_initial; n_initial], options);
  
    %Actualisation de la j eme case du vecteur temps avec le toc
    %d'ex�cution relatif � la tol�rance i
    temps(j) = toc ;
    
    %Actualisation de la j eme case du vecteur tolerance avec i
    tolerance(j) = i ;
 
    %Mise � jour compteur et tol�rance
    j = j +1 ;
    i =i /10 ;
end

%Affichage du graphique
plot ( tolerance , temps);
title('Temps ex�cution en fonction de -log10(tolerance)');
xlabel('-log10(tolerance) (/)');
ylabel('temps (s)');
axis([0 11 0 1.8]);
grid;
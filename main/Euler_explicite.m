% On nettoie l'espace de travail
clc;clear all;close all;

% Ajustement de paramètres quant à l'affichage des graphiques
screensize = get( groot, 'Screensize' );
pourcentage=80;
Position=[(100-pourcentage)/100*screensize(3:4)/2 screensize(3:4)*pourcentage/100];
set(0,'defaultFigurePosition',Position)
set(0,'defaultfigurecolor',[1 1 1])
set(0,'defaultaxesfontsize',15);
set(0,'defaulttextfontsize',18);
set(0,'defaultaxeslinewidth',1.5);
set(0,'defaultlinelinewidth',1.5);

%Initialisation
i = 1;
temps_simu = 100;
n = 0.5;
V = -1.5;
dt = 0.05; 

%Initialisation des autres données sur base de celles ci-dessus
I_app = [i; i];
temps_I_app = [0; temps_simu];
temps = 0:dt:temps_simu; 
%Facultatif, cela ne sert qu'à rendre le vecteur temps "comme les autres", 
%i.e., en colonne (question d'esthétisme et de cohérence)
temps = temps.';
etats = zeros(length(temps)-1, 2);
etats(1, :) = [V n];

%On boucle jusqu'à length(temps)-1 pour éviter le dépassement des bornesµ
%La boucle effectue simplement l'algorithme à proprement parlé
for t=1:length(temps)-1 
    %Calcul d'un vecteur [deriv V; deriv n]
    deriv_cur = nagumo(temps(t), etats(t, :), I_app, temps_I_app);
    %Application de l'algorithme d'Euler explicite pour la (t+1)e ligne (la
    %première ligne est initialisée (L25))
    etats(t+1, :) = etats(t, :) + dt*deriv_cur.';

end

%Affichage des graphiques V(t) et n(t)
subplot(1, 2, 1)
plot(temps, etats(:, 1));
xlabel('temps t (ms)')
ylabel('V (/)')
grid
title('Euler explicite : V(t)')

subplot(1, 2, 2)
plot(temps, etats(:, 2));
xlabel('temps t (ms)')
ylabel('n (/)')
grid
title('Euler explicite : n(t)')

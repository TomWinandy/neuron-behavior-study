%Définition de deux variables de type symbolique
syms V n

%Utilisation de la fonction jacobian de matlab pour calculer la matrice
%jacobienne
jacobian([V - V^3/3 - n^2, 0.1*(2/(1+exp(-5*V)) - n)], [V, n])
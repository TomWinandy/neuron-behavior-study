x = etats; 
%le vecteur etats contient toutes les valeurs de V(t) (1ere colonne)
%et toutes les valeurs de n(t) (2e colonne), ces valeurs ayant été obtenues
%grâce à Euler_explicite (et un pas peu élevé pour bien voir l'évolution
%des valeurs propres au fil des itérations)

%Initialisation d'un tableau de valeurs propres
valeurspropres = zeros(size(etats));

%On boucle sur toutes les valeurs d'etats et pour chaque couple (V,n) on
%calcule les valeurs propres de la matrice jacobienne
for j=1: length(etats)
    
    J = [1 - x(j, 1)^2 , -2*x(j, 2) ; exp(-5* x(j,1)) / (1+exp(-5*x(j,1)))^2 , -0.1];
    valeurspropres(j, :) = eig(J);
    
end
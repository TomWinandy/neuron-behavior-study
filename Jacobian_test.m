x = etats; 
%le vecteur etats contient toutes les valeurs de V(t) (1ere colonne)
%et toutes les valeurs de n(t) (2e colonne), ces valeurs ayant �t� obtenues
%gr�ce � Euler_explicite (et un pas peu �lev� pour bien voir l'�volution
%des valeurs propres au fil des it�rations)

%Initialisation d'un tableau de valeurs propres
valeurspropres = zeros(size(etats));

%On boucle sur toutes les valeurs d'etats et pour chaque couple (V,n) on
%calcule les valeurs propres de la matrice jacobienne
for j=1: length(etats)
    
    J = [1 - x(j, 1)^2 , -2*x(j, 2) ; exp(-5* x(j,1)) / (1+exp(-5*x(j,1)))^2 , -0.1];
    valeurspropres(j, :) = eig(J);
    
end
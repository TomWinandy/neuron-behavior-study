function [ der ] = derivee( temps, valeurs )
    %Initialisation de "der" , vecteur ligne rempli de zéros
    der = zeros(1,length(valeurs));

    % Nous utilisons ici simplement la dérivée classique, comme définie
    % traditionnellement. NB : l'utilisation de la différence finie centrée
    % aurait sans doute permis une plus grande précision

    %f'(x) = (f(x+h)-f(x-h))/h
    der(1 : end-1) = (valeurs(2:end)-valeurs(1:(end-1)))./(temps(2:end)-temps(1:(end-1)));

    % f'(xend) = (f(xend)-f(xend-h))/h car il n'y a plus de "voisin à
    % droite" de la dernière valeur
    der(end) = (valeurs(end) - valeurs(end-1))/(temps(end) - temps(end-1));

    end
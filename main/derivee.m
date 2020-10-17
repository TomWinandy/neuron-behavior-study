function [ der ] = derivee( temps, valeurs )
    %Initialisation de "der" , vecteur ligne rempli de z�ros
    der = zeros(1,length(valeurs));

    % Nous utilisons ici simplement la d�riv�e classique, comme d�finie
    % traditionnellement. NB : l'utilisation de la diff�rence finie centr�e
    % aurait sans doute permis une plus grande pr�cision

    %f'(x) = (f(x+h)-f(x-h))/h
    der(1 : end-1) = (valeurs(2:end)-valeurs(1:(end-1)))./(temps(2:end)-temps(1:(end-1)));

    % f'(xend) = (f(xend)-f(xend-h))/h car il n'y a plus de "voisin �
    % droite" de la derni�re valeur
    der(end) = (valeurs(end) - valeurs(end-1))/(temps(end) - temps(end-1));

    end
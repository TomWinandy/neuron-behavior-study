function [temps, etats] = intermediaire(V, n, i, temps_simu, dt)

    %Il s'agit d'un copié-collé d'Euler_explicite utilisé pour Euler_test, sous
    %forme d'une fonction prenant en entrée un pas de temps et les paramètres
    %classiques, i.e. V, n, intensité, temps simulation et renvoyant les
    %valeurs de V et n ainsi que le vecteur temps correspondant. Se reporter 
    %à Euler_explicite pour des commentaires plus détaillés sur le code

    I_app = [i; i];
    temps_I_app = [0; temps_simu];
    temps = 0:dt:temps_simu;
    temps = temps.';
    etats = zeros(length(temps)-1, 2);
    etats(1, :) = [V n];

    for t=1:length(temps)-1
        deriv_cur = nagumo(temps(t), etats(t, :), I_app, temps_I_app);
        etats(t+1,:) = etats(t, :) + dt*deriv_cur';

    end
end
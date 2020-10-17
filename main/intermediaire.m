function [temps, etats] = intermediaire(V, n, i, temps_simu, dt)

    %Il s'agit d'un copi�-coll� d'Euler_explicite utilis� pour Euler_test, sous
    %forme d'une fonction prenant en entr�e un pas de temps et les param�tres
    %classiques, i.e. V, n, intensit�, temps simulation et renvoyant les
    %valeurs de V et n ainsi que le vecteur temps correspondant. Se reporter 
    %� Euler_explicite pour des commentaires plus d�taill�s sur le code

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
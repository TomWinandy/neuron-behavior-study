function [ deriv_V_n ] = nagumo( temps, etats, I_app, temps_I_app )
    %deriv_V_n représentera un vecteur colonne contenant dV/dt et dn/dt
    %temps = scalaire
    %etats = vecteur [V n]
    %I_app = vecteur représentant le courant I_app aux instants définis par
    %temps_I_app (cfr. Question 4)
    %temps_I_app = vecteur de la taille de I_app
   
    %Initialisation selon les données du problème
    n0 = 0;
    e = 0.1;
    %NB : interp1 est une interpolation linéaire par défaut (cfr : aide
    %Matlab)
    I_eff = interp1(temps_I_app, I_app, temps); 

    %Initialisation à 0 du vecteur solution
    deriv_V_n = zeros(2, 1);
    
    %Mise à jour du vecteur grâce aux seconds membres des EDO
    deriv_V_n(1) = etats(1) - etats(1)^3 / 3 - etats(2)^2 + I_eff;
    deriv_V_n(2) = e*( 2/(1 + exp(-5*etats(1))) + n0 - etats(2));


end


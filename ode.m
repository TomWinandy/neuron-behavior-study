function [T, V_n] = ode(V_initial, n_initial, t_simulation, i)
    %T est un  vecteur colonne
    %V_n est un  vecteur de deux colonnes
    %Les autres param�res sont de simples scalaires
    
    %Initialisation (dans le cadre des questions 2 et 3, i.e intensit�
    %constante)
    I_app = [i; i];
    temps_I_app = [0; t_simulation];

    %D�finition de la tol�rance relative et absolue (cfr. Rapport)
    options = odeset('RelTol', 1e-7, 'AbsTol', [1e-7, 1e-4]);
    
    %Fonction ode45 en tant que telle
    [T, V_n] = ode45(@(temps, etats)nagumo(temps, etats, I_app, temps_I_app), [0; t_simulation], [V_initial; n_initial], options);
    %La 1ere parenth�se sert � donner � nagumo les variables manipuli�es. En effet, 
    %il n'en connait que les premi�res valeurs et doit utiliser les it�r�s pour
    %continuer. Dans ode45, on appelle nagumo et ode45 va lui-m�me boucler sur
    %temps et etats. Il faut donc lui "dire" de quoi d�pendent les fonctions
    %(i.e. nagumo) qu'il traite.

    %Affichage des graphiques -> utiis� pour le Milestone 2 mais retir�
    %ensuite car les questions 3 utilisent de mani�re r�p�t�e la fonction
    %ode et il est donc mal venu de perdre un temps d'ex�cution
    %consid�rable � cause de l'affichage (qui est de toute mani�re inutile)
    
    %subplot(1, 2, 1)
    %plot(T, V_n(:,1));
    %xlabel('temps t (ms)')
    %ylabel('V (/)')
    %grid
    %title('ode45 : V(t)')
    
    %subplot(1, 2, 2)
    %plot(T, V_n(:,2));
    %xlabel('temps t (ms)')
    %ylabel('n (/)')
    %grid
    %title('ode45 : n(t)')
end

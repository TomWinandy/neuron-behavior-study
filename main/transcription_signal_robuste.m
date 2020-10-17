function [ binaire ] = transcription_signal_robuste( V_init, n_init, I_app, temps_I_app )
   
    %Conditions pour que la fonction produise le r�sultat attendu :
    % 1) dur�e s�parant les intervalles durant lesquels I est appliqu� > 
    % dur�e du plus grand intervalle durant lequel I est appliqu�.
    % 2) Le vecteur temps_I_app commence par 0, temps_I_app(2), temps_I_app(3),
    % temps_I_app(4), o� [temps_I_app(3), temps_I_app(4)] = dur�e du premier 
    % courant appliqu�.
    % Exemple : I_app = [0 0 0.6 0.6 0 0 0.75 0.75 0 0 1.2 1.2 0 0]
    % temps_I_app = [0 99.9999 100 119.9999 120 199.9999 200 219.9999
    % 220 299.9999 300 349.9999 350 499.9999]
    % 3) Le courant est appliqu� pendant un temps suffisant pour que le
    % neurone commence � r�agir (sup�rieur � quelques ms...)

    %Seuil pour �viter les micro-oscillations
    seuil = 0.1;
    %Initialisation des vecteurs forc�ment utilis�s dans le code
    maxima = [];
    locs = [];
    multiple_spikes = [];
    %Variable pour g�rer entr�e-sortie de la boucle
    test = 0;
    
    %D�finition de la tol�rance relative et absolue pour ode45 (cfr.
    %Question 2.3)
    options = odeset('RelTol', 1e-7, 'AbsTol', [1e-7, 1e-4]);
    
    %Fonction ode45 pour trouver les valeurs du temps, de V et de n
    [T, V_n] = ode45(@(temps, etats)nagumo(temps, etats, I_app, temps_I_app), [0; temps_I_app(end)], [V_init; n_init], options);
    
    %On boucle tant que les donn�es renvoy�es par cherche_max ne sont pas
    %valides
    while test == 0
        
        %Utilisation de cherche_max pour d�terminer les maxima et les temps
        %correspondants
        [maxima , locs] = cherche_max(V_n(:, 1)', T', seuil);

        %Pour se pr�munir des �ventuels cas particuliers, on calcule n
        %n repr�sente le "nombre" de courants constants envoy�s (floor est la
        %fonction plancher, et ce n correspond � floor(length(temps_I_app)) par
        %construction de temps_I_app)
        n = floor(length(temps_I_app)/4);
      
        %On s'attend � ce qu'il y ait autant de maxima (significatifs ou non)
        %que de courants envoy�s, sinon, c'est qu'il y a un probl�me.

        %Si on a trouv� trop peu de maxima, c'est sans doute que le seuil
        %choisi �tait trop l�che et qu'un "mini-maximum" nous a �chapp�. On
        %relance donc l'algorithme avec un seuil plus bas (m�me si c'est
        %peu probable que cela arrive)
        if length(locs) < n 
            seuil = seuil/2;
                 
        %Si on a trouv� plus de maxima que de courants appliqu�s, cela signifie
        %que certains courants ont �t� appliqu�s suffisamment longtemps pour
        %produire plus d'un spike. Il ne faut donc pas en tenir compte dans la
        %cr�ation du tableau de 0 et de 1 renvoy� � la fin de cette fonction
        elseif length(locs) > n
            %On met � jour test pour sortir de la boucle
            test = 1;
            
            %locs_diff est un tableau de taille length(locs)-1 contenant les
            %diff�rences entre les �l�ments successifs de locs (cfr. aide
            %Matlab)
            locs_diff = diff(locs);

            %duree est un tableau de taille length(temps_I_app)-1 contenant les
            %diff�rences entre les �l�ments successifs de locs (cfr. aide
            %Matlab). Il est donc de la forme
            %[temps_de_non_application_de_courant, tr�s petit intervalle,
            %temps_d_application_de_courant, tr�s petit intervalle,...]
            duree = diff(temps_I_app);

            %Initialisation d'un compteur et d'un vecteur duree_intervalle
            %contenant la dur�e de chaque intervalle d'application de courant
            j=1;
            duree_intervalle = zeros(n,1);
        
            %On boucle uniquement sur les �l�ments correspondant � la dur�e
            %d'application d'un courant
            for i=3:4:length(duree)
                %On affecte donc comme pr�vu la dur�e de l'intervalle
                %d'application de courant � la j eme case de
                %duree_intervalle
                duree_intervalle(j) = duree(i);
                %Incr�mentation compteur (indice)
                j = j+1;
            end %fin -for- remplissage duree_intervalle
           
            %intervalle correspond � la dur�e du plus long intervalle
            %d'application de courant (< la dur�e s�parant 2 applications
            %successives d'apr�s la condition 1)
            intervalle = max(duree_intervalle);
            
            %multiple_spikes contient les positions dans locs_diff dont
            %l'�l�ment est inf�rieur � l'intervalle, i.e. contient les
            %positions dans locs dont l'�cart avec la valeur suivante est
            %inf�rieur � la taille de l'intervalle d'application. Cela
            %signifie que multiple_spikes contient les positions des
            %maxima "en trop", qui ne doivent pas �tre pris en compte 
            %car ils surviennent durant le m�me intervalle d'application
            %qu'un autre.
            multiple_spikes = find(locs_diff < intervalle);
            
            %Pour tous ces maxima "non-valides" (� la position k),
            %on donne une valeur d'erreur � locs(k+1) (car c'est le premier
            %pic d'une s�rie le plus repr�sentatif (le dernier pouvant �tre
            %interrompu par la fin d'application de courant))
            for i=1:length(multiple_spikes)
                locs(multiple_spikes(i)+1) = -1;
            end %fin -for- changement des �l�ments de locs
      
        %Sinon, tout est ok et il nous suffit de sortir de la boucle
        else
            test = 1;
        end %fin -if- test longueur locs
    
    end %fin -while- test
    
    %On initialise binaire, le tableau de sortie et un compteur
    binaire = zeros(length(locs)-length(multiple_spikes), 1);
    j = 1;
  
    %Pour chaque valeur acceptable de locs (i.e. diff�rente de -1), on
    %v�rifie si le maximum correspondant est >0 (Iapp est donc suffisant et
    %on renvoie 1) ou <0 (Iapp est donc insuffisant et on renvoie 0)
    for i=1: length(locs)
        if locs(i) ~= -1
            if maxima(i) < 0
               binaire(j) = 0;
            else
               binaire(j) = 1;
            end %fin -if- test signe max
        j = j+1;
        end %fin -if- validit� locs(i)
    end %fin -for- remplissage binaire 
end %fin fonction


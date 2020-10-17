function [ binaire ] = transcription_signal_robuste( V_init, n_init, I_app, temps_I_app )
   
    %Conditions pour que la fonction produise le résultat attendu :
    % 1) durée séparant les intervalles durant lesquels I est appliqué > 
    % durée du plus grand intervalle durant lequel I est appliqué.
    % 2) Le vecteur temps_I_app commence par 0, temps_I_app(2), temps_I_app(3),
    % temps_I_app(4), où [temps_I_app(3), temps_I_app(4)] = durée du premier 
    % courant appliqué.
    % Exemple : I_app = [0 0 0.6 0.6 0 0 0.75 0.75 0 0 1.2 1.2 0 0]
    % temps_I_app = [0 99.9999 100 119.9999 120 199.9999 200 219.9999
    % 220 299.9999 300 349.9999 350 499.9999]
    % 3) Le courant est appliqué pendant un temps suffisant pour que le
    % neurone commence à réagir (supérieur à quelques ms...)

    %Seuil pour éviter les micro-oscillations
    seuil = 0.1;
    %Initialisation des vecteurs forcément utilisés dans le code
    maxima = [];
    locs = [];
    multiple_spikes = [];
    %Variable pour gérer entrée-sortie de la boucle
    test = 0;
    
    %Définition de la tolérance relative et absolue pour ode45 (cfr.
    %Question 2.3)
    options = odeset('RelTol', 1e-7, 'AbsTol', [1e-7, 1e-4]);
    
    %Fonction ode45 pour trouver les valeurs du temps, de V et de n
    [T, V_n] = ode45(@(temps, etats)nagumo(temps, etats, I_app, temps_I_app), [0; temps_I_app(end)], [V_init; n_init], options);
    
    %On boucle tant que les données renvoyées par cherche_max ne sont pas
    %valides
    while test == 0
        
        %Utilisation de cherche_max pour déterminer les maxima et les temps
        %correspondants
        [maxima , locs] = cherche_max(V_n(:, 1)', T', seuil);

        %Pour se prémunir des éventuels cas particuliers, on calcule n
        %n représente le "nombre" de courants constants envoyés (floor est la
        %fonction plancher, et ce n correspond à floor(length(temps_I_app)) par
        %construction de temps_I_app)
        n = floor(length(temps_I_app)/4);
      
        %On s'attend à ce qu'il y ait autant de maxima (significatifs ou non)
        %que de courants envoyés, sinon, c'est qu'il y a un problème.

        %Si on a trouvé trop peu de maxima, c'est sans doute que le seuil
        %choisi était trop lâche et qu'un "mini-maximum" nous a échappé. On
        %relance donc l'algorithme avec un seuil plus bas (même si c'est
        %peu probable que cela arrive)
        if length(locs) < n 
            seuil = seuil/2;
                 
        %Si on a trouvé plus de maxima que de courants appliqués, cela signifie
        %que certains courants ont été appliqués suffisamment longtemps pour
        %produire plus d'un spike. Il ne faut donc pas en tenir compte dans la
        %création du tableau de 0 et de 1 renvoyé à la fin de cette fonction
        elseif length(locs) > n
            %On met à jour test pour sortir de la boucle
            test = 1;
            
            %locs_diff est un tableau de taille length(locs)-1 contenant les
            %différences entre les éléments successifs de locs (cfr. aide
            %Matlab)
            locs_diff = diff(locs);

            %duree est un tableau de taille length(temps_I_app)-1 contenant les
            %différences entre les éléments successifs de locs (cfr. aide
            %Matlab). Il est donc de la forme
            %[temps_de_non_application_de_courant, très petit intervalle,
            %temps_d_application_de_courant, très petit intervalle,...]
            duree = diff(temps_I_app);

            %Initialisation d'un compteur et d'un vecteur duree_intervalle
            %contenant la durée de chaque intervalle d'application de courant
            j=1;
            duree_intervalle = zeros(n,1);
        
            %On boucle uniquement sur les éléments correspondant à la durée
            %d'application d'un courant
            for i=3:4:length(duree)
                %On affecte donc comme prévu la durée de l'intervalle
                %d'application de courant à la j eme case de
                %duree_intervalle
                duree_intervalle(j) = duree(i);
                %Incrémentation compteur (indice)
                j = j+1;
            end %fin -for- remplissage duree_intervalle
           
            %intervalle correspond à la durée du plus long intervalle
            %d'application de courant (< la durée séparant 2 applications
            %successives d'après la condition 1)
            intervalle = max(duree_intervalle);
            
            %multiple_spikes contient les positions dans locs_diff dont
            %l'élément est inférieur à l'intervalle, i.e. contient les
            %positions dans locs dont l'écart avec la valeur suivante est
            %inférieur à la taille de l'intervalle d'application. Cela
            %signifie que multiple_spikes contient les positions des
            %maxima "en trop", qui ne doivent pas être pris en compte 
            %car ils surviennent durant le même intervalle d'application
            %qu'un autre.
            multiple_spikes = find(locs_diff < intervalle);
            
            %Pour tous ces maxima "non-valides" (à la position k),
            %on donne une valeur d'erreur à locs(k+1) (car c'est le premier
            %pic d'une série le plus représentatif (le dernier pouvant être
            %interrompu par la fin d'application de courant))
            for i=1:length(multiple_spikes)
                locs(multiple_spikes(i)+1) = -1;
            end %fin -for- changement des éléments de locs
      
        %Sinon, tout est ok et il nous suffit de sortir de la boucle
        else
            test = 1;
        end %fin -if- test longueur locs
    
    end %fin -while- test
    
    %On initialise binaire, le tableau de sortie et un compteur
    binaire = zeros(length(locs)-length(multiple_spikes), 1);
    j = 1;
  
    %Pour chaque valeur acceptable de locs (i.e. différente de -1), on
    %vérifie si le maximum correspondant est >0 (Iapp est donc suffisant et
    %on renvoie 1) ou <0 (Iapp est donc insuffisant et on renvoie 0)
    for i=1: length(locs)
        if locs(i) ~= -1
            if maxima(i) < 0
               binaire(j) = 0;
            else
               binaire(j) = 1;
            end %fin -if- test signe max
        j = j+1;
        end %fin -if- validité locs(i)
    end %fin -for- remplissage binaire 
end %fin fonction


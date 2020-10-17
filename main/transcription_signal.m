function [ binaire ] = transcription_signal( V_init, n_init, duree_application, periode, I)
   
    %Seuil pour éviter les micro-oscillations
    seuil = 0.1;
    
    %Initialisation grâce à la fonction creation_vecteurs_I_app
    [ I_app, temps_I_app ] = creation_vecteurs_I_app(duree_application, periode, I);
    
    %Initialisation du tableau output
    binaire = zeros(length(I), 1);
    
    %Définition de la tolérance relative et absolue pour ode45 (cfr. idem
    %Question 2.3)
    options = odeset('RelTol', 1e-7, 'AbsTol', [1e-7, 1e-4]);
    
    %Fonction ode45 pour trouver les valeurs du temps, de V et de n
    [T, V_n] = ode45(@(temps, etats)nagumo(temps, etats, I_app, temps_I_app), [0; temps_I_app(end)], [V_init; n_init], options);
        
    %Utilisation de cherche_max pour déterminer les maxima et les temps
    %correspondants (.' car colonnes au lieu de lignes)
    [maxima , locs] = cherche_max(V_n(:, 1).', T.', seuil);
    
    %Initialisation d'un compteur pour se déplacer dans locs et maxima
    j = 1;
    
    %On souhaite obtenir une valeur (0 ou 1) pour chaque courant de I. On
    %boucle donc sur chaque valeur contenue dans I et pour chacune on teste
    %si un maximum est produit et si celui-ci est supérieur à 0 (condition
    %pour afficher un 1). Cette boucle n'est effectuée que si au moins un
    %maximum a été détecté (sans quoi on cherche l'élément j d'un tableau
    %vide, ce qui cause une erreur)
    if ~isempty(locs)
        for i=1:length(I)

            %Si le locs(j) est dans l'intervalle de temps durant lequel I(i)
            %est appliqué, on s'y intéresse : si le maximum associé est positif
            %binaire(i) vaudra 1 et inversement
            if j <= length(locs) && locs(j)<= (duree_application + (i-1) * periode) && locs(j) >= ((i-1)*periode)
                if maxima(j) < 0
                    
                    binaire(i) = 0;
                else
                    
                    binaire(i) = 1;
                end %fin -if- test signe max
                %On passe à la case suivante
                j=j+1;
                
                %Cela ne sert plus à rien de prendre en compte les autres
                %maxima de cet intervalle de temps (il peut en y avoir
                %plusieurs dans un même intervalle si le courant est élevé et
                %duree_impulsion est longue), on les passe donc tous
                while j < length(locs) && locs(j)<= (duree_application + (i-1) * periode) && locs(j) >= ((i-1)*periode)
                    j = j+1;
                end %fin -while- avancer dans les max

            %Si locs(j) est > que i*periode (idem que > que (i-1)*periode + 
            %duree_application puisque aucun courant n'est appliqué entre temps) 
            %cela signifie qu'aucun maxima n'a été détecté durant l'intervalle 
            %de temps [ (i-1)*periode ; (i-1)*periode + duree_application ], 
            %on actualise donc la i eme case de binaire à 0. NB : cette
            %opération est facultative car binaire est initialement rempli de 0
            else
                binaire(i) = 0;

            end %fin -if- test position locs(j) par rapport à I(i)
        end %fin -for- boucle pour remplir binaire     
    end %fin -if- test existence de maxima
end %fin fonction


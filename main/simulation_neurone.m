function [ frequence ] = simulation_neurone( Iapp )

    %Initialisation des données
    V_init = -1.5;
    n_init = 0.5;
    temps_simu = 200;
    %tolerance sur l'écart type entre les valeurs de fréquence
    tolerance = 0.05;
    %définition d'une variable seuil à partir de laquelle le premier pic
    %produit par le neurone est trop peu régulier que pour entrer dans le
    %calcul de la fréquence (cfr. Rapport)
    Iapp_trop_gros_spike = 1;
    %seuil_max définit l'écart minimal souhaité entre un minimum et un
    %maximum consécutifs
    seuil_min = 0.1;

    %Si le courant entré est négatif, la recherche ne peut avoir lieu, on
    %renvoie une valeur d'erreur (par exemple NaN)
    if Iapp <0
        frequence = NaN;
    
    %Sinon, on peut procéder à la recherche d'une fréquence
    else
        %Les vecteurs temps et etats sont remplis grâce à la fonction ode
        [temps, etats] = ode(V_init, n_init, temps_simu, Iapp); 
     
        %Initialisation de la frequence
        frequence = 0;
        
        % On utilise la fonction cherche_max pour repérer les instants auxquels 
        %se produisent des maxima. ~ signifie que les maxima, bien que calculés 
        %ne sont pas assignés à quelque variable dans ce code (mais
        %pourraient servir autre part : notre volonté était de créer une
        %fonction cherche_max assez générale). L'opérateur .' est utilisé
        %car cherche_max a été implémenté avec des vecteurs lignes.
        %seuil_min est l'écart minimal que nous désirons avoir entre un
        %minimum et un maximum consécutifs (pour se prémusir de
        %micro-oscillations dûes aux erreurs de calcul d'ode)
        %NB : etats(:,1) contient toutes les valeurs de V
        [ ~ , locs ] = cherche_max(etats(:,1).', temps.' , seuil_min);

        %On définit une variable j qui servira d'indice dans le vecteur locs. 
        %Si I_app est supérieur au seuil fixé, on commence au deuxième
        %indice de locs, i.e. j=2, sinon j=1
        if Iapp > Iapp_trop_gros_spike
            j=2;
        else
            j=1;
        end
        
        %Si on a au moins j+1 maxima (càd au moins 2 exploitables), on 
        %essaye de calculer la fréquence
        if length(locs)>j
            %Initialisation d'un vecteur qui contiendra chaque fréquence
            std_freq = zeros(length(locs)-j, 1);
            
            %La fréquence est ensuite calculée comme la moyenne des fréquences
            %calculables entre deux pics successifs. NB : on aurait sans
            %doute pu calculer celle-ci grâce à la fonction mean mais on
            %voulait de toute manière remplir le tableau de std_freq
            for i=j:length(locs)-1
                std_freq(i-(j-1)) = 1000/(locs(i+1) - locs(i));
                frequence = frequence + std_freq(i-(j-1));
             
            end %fin -for- calcul des fréquences
            
            frequence = frequence / (length(locs)-j);
            
            %test représente l'écart-type sur l'ensemble des fréquences.
            %S'il est trop important on considère les spikes irréguliers et
            %la fréquence nulle
            test = std(std_freq);
            if test > tolerance * frequence
                frequence = 0;
            end %fin -if- test régularité
       
        %Sinon, on considère que la fréquence est nulle
        else
            frequence = 0;
        end %fin -if- test longueur locs
        
    end %fin if -vérification Iapp
    
end %fin fonction


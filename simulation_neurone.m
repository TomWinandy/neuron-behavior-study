function [ frequence ] = simulation_neurone( Iapp )

    %Initialisation des donn�es
    V_init = -1.5;
    n_init = 0.5;
    temps_simu = 200;
    %tolerance sur l'�cart type entre les valeurs de fr�quence
    tolerance = 0.05;
    %d�finition d'une variable seuil � partir de laquelle le premier pic
    %produit par le neurone est trop peu r�gulier que pour entrer dans le
    %calcul de la fr�quence (cfr. Rapport)
    Iapp_trop_gros_spike = 1;
    %seuil_max d�finit l'�cart minimal souhait� entre un minimum et un
    %maximum cons�cutifs
    seuil_min = 0.1;

    %Si le courant entr� est n�gatif, la recherche ne peut avoir lieu, on
    %renvoie une valeur d'erreur (par exemple NaN)
    if Iapp <0
        frequence = NaN;
    
    %Sinon, on peut proc�der � la recherche d'une fr�quence
    else
        %Les vecteurs temps et etats sont remplis gr�ce � la fonction ode
        [temps, etats] = ode(V_init, n_init, temps_simu, Iapp); 
     
        %Initialisation de la frequence
        frequence = 0;
        
        % On utilise la fonction cherche_max pour rep�rer les instants auxquels 
        %se produisent des maxima. ~ signifie que les maxima, bien que calcul�s 
        %ne sont pas assign�s � quelque variable dans ce code (mais
        %pourraient servir autre part : notre volont� �tait de cr�er une
        %fonction cherche_max assez g�n�rale). L'op�rateur .' est utilis�
        %car cherche_max a �t� impl�ment� avec des vecteurs lignes.
        %seuil_min est l'�cart minimal que nous d�sirons avoir entre un
        %minimum et un maximum cons�cutifs (pour se pr�musir de
        %micro-oscillations d�es aux erreurs de calcul d'ode)
        %NB : etats(:,1) contient toutes les valeurs de V
        [ ~ , locs ] = cherche_max(etats(:,1).', temps.' , seuil_min);

        %On d�finit une variable j qui servira d'indice dans le vecteur locs. 
        %Si I_app est sup�rieur au seuil fix�, on commence au deuxi�me
        %indice de locs, i.e. j=2, sinon j=1
        if Iapp > Iapp_trop_gros_spike
            j=2;
        else
            j=1;
        end
        
        %Si on a au moins j+1 maxima (c�d au moins 2 exploitables), on 
        %essaye de calculer la fr�quence
        if length(locs)>j
            %Initialisation d'un vecteur qui contiendra chaque fr�quence
            std_freq = zeros(length(locs)-j, 1);
            
            %La fr�quence est ensuite calcul�e comme la moyenne des fr�quences
            %calculables entre deux pics successifs. NB : on aurait sans
            %doute pu calculer celle-ci gr�ce � la fonction mean mais on
            %voulait de toute mani�re remplir le tableau de std_freq
            for i=j:length(locs)-1
                std_freq(i-(j-1)) = 1000/(locs(i+1) - locs(i));
                frequence = frequence + std_freq(i-(j-1));
             
            end %fin -for- calcul des fr�quences
            
            frequence = frequence / (length(locs)-j);
            
            %test repr�sente l'�cart-type sur l'ensemble des fr�quences.
            %S'il est trop important on consid�re les spikes irr�guliers et
            %la fr�quence nulle
            test = std(std_freq);
            if test > tolerance * frequence
                frequence = 0;
            end %fin -if- test r�gularit�
       
        %Sinon, on consid�re que la fr�quence est nulle
        else
            frequence = 0;
        end %fin -if- test longueur locs
        
    end %fin if -v�rification Iapp
    
end %fin fonction


function [max, locs ] = cherche_max( data , temps , seuil )
    %Ddata = dérivée de data
    Ddata = derivee(temps, data);
    
    %signData est un vecteur rempli de 1, -1 et 0 (suivant le signe de
    %Ddata(i) (positif, négatif ou nul))
    signDdata = sign(Ddata);
    
    %Dérivée de signDdata : calcul  de la variation du signe de la dérivée.
    %DsignDdata est donc rempli majoritairement de 0, mais également de valeurs
    %négatives (-1 (ou -2)) au moment où la fonction réalise un maximum et
    %positives (1 (ou 2)) au moment où elle réalise un minimum
    DsignDdata=derivee( temps , signDdata );
    
    %Imax est donc un vecteur contenant l'indice des points où la dérivée première 
    %est passée de positive à négative, i.e., les potentiels maxima. Même
    %raisonnement pour Imin, dans l'autre sens
    Imax=find(DsignDdata<0);
    Imin=find(DsignDdata>0);
     
    %Création de deux vecteurs, initialement nuls
    max=[];
    locs=[];
    
    %Création d'un vecteur ligne contenant toutes les Imin puis toutes les Imax
    I = [Imin Imax];
    
    %Itrie correspond donc au vecteur I trié, de sorte qu'il contient
    %successivement l'indice correspondant à un minimum puis celui 
    %d'un maximum et ainsi de suite
    Itrie = sort(I);
    
    %Initialisation de l'indice des tableaux max et locs
    J=1;
    
    %Condition pour se prémunir de quelques rares cas très particuliers où
    %le vecteur Itrie ne compterait qu'un élément, ce qui entrainerait une
    %erreur à la ligne 57
    if length(Itrie)>1
        
        for i=1:length(Itrie) 
            %find renvoie un vecteur contenant la position de Itrie(i) dans Imax
            %si Itrie(i) est un element de Imax. isempty renvoie 1 si find 
            %renvoie un vecteur vide, 0 sinon. Donc ~isempty vaudra 1 si find 
            %n'est pas nul, i.e, si Itrie(i) est un maximum (on rentre donc
            %dans la boucle.
            %Le 1 sert à "protéger" find, pour dire qu'on ne cherche bien que le
            %premier élément en commun (cfr. aide Matlab)
            if ~isempty(find(Imax == Itrie(i), 1))

                %Imaximum est donc l'élément maximum en question 
                Imaximum=Itrie(i);

                %Si on est au début du tableau, Iminimum = l'élément après
                %Imaximum (pas d'autre choix)
                if i==1
                    Iminimum = Itrie(i+1);

                %Si on est à la fin du tableau, Iminimum = l'élément avant 
                %Imaximum (pas d'autre choix)
                elseif i==length(Itrie)  
                    Iminimum = Itrie(i-1);

                %Si on est au milieu, on peut considérer le minimum précédent 
                %ou suivant. On choisit celui le plus proche en terme de valeur
                %(data) de data(Imaximum) et ce pour se prémunir du pire des
                %cas (au niveau de la vérification du seuil)
                else
                   
                    %Le vecteur différence contient les écarts entre
                    %data(Imaximum) et la valeur qui le suit, et celle qui le
                    %précède. Il suffit dès lors de trouver le minimum
                    difference = [data(Itrie(i))-data(Itrie(i+1)), data(Itrie(i))-data(Itrie(i-1))];
                    indice = find(min(difference)==difference);

                    %En fonction de la postion de ce minimum, on assigne une
                    %valeur à Iminimum
                    if indice == 1
                        Iminimum = Itrie(i+1);
                    else
                        Iminimum = Itrie(i-1);
                    end
                end %fin -if- Iminimum

                %Pour se prémunir de la détection de "micro-oscillations", on
                %vérifie que l'écart entre un maximum et le minimum qui le
                %suit (resp. précède si on est au bout du vecteur Itrie) est
                %supérieur à un certain seuil (cfr. Rapport pour plus
                %d'explications)

                if ( data(Imaximum) - data(Iminimum) >= seuil )
                   %max contient la valeur du maximum
                   max(J) = data(Imaximum);
                   %locs contient le temps auquel on trouve un maximum
                   locs(J) = temps(Imaximum);
                   %On met à jour le compteur (l'indice)
                   J=J+1;
                end %fin -if- vérification seuil
            
            end %fin -if- vérification maximum
            
        end %fin -for- boucle sur les éléments de Itrie

    end %fin -if- vérification taille Itrie
        
end%fin fonction
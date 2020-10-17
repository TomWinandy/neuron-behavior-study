function [max, locs ] = cherche_max( data , temps , seuil )
    %Ddata = d�riv�e de data
    Ddata = derivee(temps, data);
    
    %signData est un vecteur rempli de 1, -1 et 0 (suivant le signe de
    %Ddata(i) (positif, n�gatif ou nul))
    signDdata = sign(Ddata);
    
    %D�riv�e de signDdata : calcul  de la variation du signe de la d�riv�e.
    %DsignDdata est donc rempli majoritairement de 0, mais �galement de valeurs
    %n�gatives (-1 (ou -2)) au moment o� la fonction r�alise un maximum et
    %positives (1 (ou 2)) au moment o� elle r�alise un minimum
    DsignDdata=derivee( temps , signDdata );
    
    %Imax est donc un vecteur contenant l'indice des points o� la d�riv�e premi�re 
    %est pass�e de positive � n�gative, i.e., les potentiels maxima. M�me
    %raisonnement pour Imin, dans l'autre sens
    Imax=find(DsignDdata<0);
    Imin=find(DsignDdata>0);
     
    %Cr�ation de deux vecteurs, initialement nuls
    max=[];
    locs=[];
    
    %Cr�ation d'un vecteur ligne contenant toutes les Imin puis toutes les Imax
    I = [Imin Imax];
    
    %Itrie correspond donc au vecteur I tri�, de sorte qu'il contient
    %successivement l'indice correspondant � un minimum puis celui 
    %d'un maximum et ainsi de suite
    Itrie = sort(I);
    
    %Initialisation de l'indice des tableaux max et locs
    J=1;
    
    %Condition pour se pr�munir de quelques rares cas tr�s particuliers o�
    %le vecteur Itrie ne compterait qu'un �l�ment, ce qui entrainerait une
    %erreur � la ligne 57
    if length(Itrie)>1
        
        for i=1:length(Itrie) 
            %find renvoie un vecteur contenant la position de Itrie(i) dans Imax
            %si Itrie(i) est un element de Imax. isempty renvoie 1 si find 
            %renvoie un vecteur vide, 0 sinon. Donc ~isempty vaudra 1 si find 
            %n'est pas nul, i.e, si Itrie(i) est un maximum (on rentre donc
            %dans la boucle.
            %Le 1 sert � "prot�ger" find, pour dire qu'on ne cherche bien que le
            %premier �l�ment en commun (cfr. aide Matlab)
            if ~isempty(find(Imax == Itrie(i), 1))

                %Imaximum est donc l'�l�ment maximum en question 
                Imaximum=Itrie(i);

                %Si on est au d�but du tableau, Iminimum = l'�l�ment apr�s
                %Imaximum (pas d'autre choix)
                if i==1
                    Iminimum = Itrie(i+1);

                %Si on est � la fin du tableau, Iminimum = l'�l�ment avant 
                %Imaximum (pas d'autre choix)
                elseif i==length(Itrie)  
                    Iminimum = Itrie(i-1);

                %Si on est au milieu, on peut consid�rer le minimum pr�c�dent 
                %ou suivant. On choisit celui le plus proche en terme de valeur
                %(data) de data(Imaximum) et ce pour se pr�munir du pire des
                %cas (au niveau de la v�rification du seuil)
                else
                   
                    %Le vecteur diff�rence contient les �carts entre
                    %data(Imaximum) et la valeur qui le suit, et celle qui le
                    %pr�c�de. Il suffit d�s lors de trouver le minimum
                    difference = [data(Itrie(i))-data(Itrie(i+1)), data(Itrie(i))-data(Itrie(i-1))];
                    indice = find(min(difference)==difference);

                    %En fonction de la postion de ce minimum, on assigne une
                    %valeur � Iminimum
                    if indice == 1
                        Iminimum = Itrie(i+1);
                    else
                        Iminimum = Itrie(i-1);
                    end
                end %fin -if- Iminimum

                %Pour se pr�munir de la d�tection de "micro-oscillations", on
                %v�rifie que l'�cart entre un maximum et le minimum qui le
                %suit (resp. pr�c�de si on est au bout du vecteur Itrie) est
                %sup�rieur � un certain seuil (cfr. Rapport pour plus
                %d'explications)

                if ( data(Imaximum) - data(Iminimum) >= seuil )
                   %max contient la valeur du maximum
                   max(J) = data(Imaximum);
                   %locs contient le temps auquel on trouve un maximum
                   locs(J) = temps(Imaximum);
                   %On met � jour le compteur (l'indice)
                   J=J+1;
                end %fin -if- v�rification seuil
            
            end %fin -if- v�rification maximum
            
        end %fin -for- boucle sur les �l�ments de Itrie

    end %fin -if- v�rification taille Itrie
        
end%fin fonction
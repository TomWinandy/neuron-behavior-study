function [ x ] = secante_bis(f, a, b)
    %Comme mentionné dans le rapport, l'idée est d'essayer de se ramener
    %aussi vite que possible à la bissection, dont on est sur de la
    %convergence si les valeurs initiales sont adéquates

    %Définition d'une tolérance comme dans la fonction sécante "normale"
    tolerance = 1e-7;
    
    %Définition d'un écart minimum désiré entre les ordonnées
    ecart_min = 1e-1;
    
    %Définition d'un décalage au cas où les valeurs initiales ont des
    %images trop proches
    decalage = abs(a-b)/4;
    
    %Définition d'une variable pour sortir de la fonction ou en
    %court-circuiter son exécution une fois la solution obtenue
    solution = 0;
    
    %Définition des deux variables manipulées dans la fonction
    x0 = min(a,b);
    x1 = max(a,b);
    
    %Définition d'une variable pour sortir de la boucle si vraiment aucune
    %solution n'est trouvée
    test = 0;
    
    %Initialisation
    y0 = f(x0);
    y1 = f(x1);
    
    %Immédiatement, on teste si on peut utiliser la bissection
    if y0*y1 < 0
        x = bissection(f, x0, x1);
    
    %Sinon, on rentre dans une boucle
    else
        
        %On sort de la boucle si on a une solution ou si on en a fait 5
        %tours (abandon lâche)
        while solution == 0 && test < 5
            
            %Initialisation du nombre d'itérations
            iter = 0;
            
            %On boucle tant que l'écart entre les ordonnées est jugé trop
            %petit, que le nombre d'itérations n'est pas trop grand et
            %qu'on n'a pas trouvé de solution
            while abs(y1-y0) < ecart_min && iter < 30 && solution == 0
                
                %Alternativement on décale x1 puis x0 suivant le tour de
                %boucle considéré
                if floor(iter/2) == 0
                    x1  = x1 + decalage;
                else
                    x0 = x0 - decalage;
                end %fin -if- iter modulo 2 = ?
                
                %Mise à jour
                y0 = f(x0);
                y1 = f(x1);
                
                %Test si la bissection est utilisable
                if y0*y1 < 0
                    x = bissection(f, x0, x1);
                    solution = 1;
                end %fin -if- test bissection
                
                %Mise à jour
                iter = iter + 1;
            end %fin -while- décalage x1 et x0
            
            %Réinitialisation de iter
            iter = 0;
            
            %Algorithme de la sécante (cfr : code sécante)
            x2 = x1 - y1*(x1-x0)/(y1-y0);
            y2 = f(x2);
            
            %On effectue le même algorithme que dans la méthode de la
            %sécante sauf qu'on teste à chaque fois si la bissection ne
            %peut pas être utilisée
            while abs(y2) > tolerance && iter<50 && solution == 0
                %Incrémentation de iter
                iter = iter + 1;
                %Mise à jour des données selon l'algorithme de la méthode
                x0 = x1;
                y0 = y1;
                x1 = x2;
                y1 = y2;
                x2 = x1 - y1*(x1-x0)/(y1-y0);
                y2 = f(x2);
                
                %Test bissection utilisable ?
                if y0*y1 <= 0
                    x = bissection(f, x0, x1);
                    solution = 1;
                end %fin -if- bissection utilisable ?
         
            end %fin -while- algorithme
            
            %On vérifie la cause de sortie de la boucle, si c'est car on a
            %trouvé la racine, on l'indique
            if abs(y2) <= tolerance
                x = x2;
                solution = 1;
            end %fin -if- vérification mode sortie
            
            %Mise à jour
            test = test + 1;
           
        end %fin -while- global
    end %fin -if- bissection directement utilisable ?  
    
    if test==5
        disp('Impossible to find a root. Our deepest apologies.');
    end %fin -if- a-t-on trouvé qqchose?
    
end %fin fonction


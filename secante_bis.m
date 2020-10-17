function [ x ] = secante_bis(f, a, b)
    %Comme mentionn� dans le rapport, l'id�e est d'essayer de se ramener
    %aussi vite que possible � la bissection, dont on est sur de la
    %convergence si les valeurs initiales sont ad�quates

    %D�finition d'une tol�rance comme dans la fonction s�cante "normale"
    tolerance = 1e-7;
    
    %D�finition d'un �cart minimum d�sir� entre les ordonn�es
    ecart_min = 1e-1;
    
    %D�finition d'un d�calage au cas o� les valeurs initiales ont des
    %images trop proches
    decalage = abs(a-b)/4;
    
    %D�finition d'une variable pour sortir de la fonction ou en
    %court-circuiter son ex�cution une fois la solution obtenue
    solution = 0;
    
    %D�finition des deux variables manipul�es dans la fonction
    x0 = min(a,b);
    x1 = max(a,b);
    
    %D�finition d'une variable pour sortir de la boucle si vraiment aucune
    %solution n'est trouv�e
    test = 0;
    
    %Initialisation
    y0 = f(x0);
    y1 = f(x1);
    
    %Imm�diatement, on teste si on peut utiliser la bissection
    if y0*y1 < 0
        x = bissection(f, x0, x1);
    
    %Sinon, on rentre dans une boucle
    else
        
        %On sort de la boucle si on a une solution ou si on en a fait 5
        %tours (abandon l�che)
        while solution == 0 && test < 5
            
            %Initialisation du nombre d'it�rations
            iter = 0;
            
            %On boucle tant que l'�cart entre les ordonn�es est jug� trop
            %petit, que le nombre d'it�rations n'est pas trop grand et
            %qu'on n'a pas trouv� de solution
            while abs(y1-y0) < ecart_min && iter < 30 && solution == 0
                
                %Alternativement on d�cale x1 puis x0 suivant le tour de
                %boucle consid�r�
                if floor(iter/2) == 0
                    x1  = x1 + decalage;
                else
                    x0 = x0 - decalage;
                end %fin -if- iter modulo 2 = ?
                
                %Mise � jour
                y0 = f(x0);
                y1 = f(x1);
                
                %Test si la bissection est utilisable
                if y0*y1 < 0
                    x = bissection(f, x0, x1);
                    solution = 1;
                end %fin -if- test bissection
                
                %Mise � jour
                iter = iter + 1;
            end %fin -while- d�calage x1 et x0
            
            %R�initialisation de iter
            iter = 0;
            
            %Algorithme de la s�cante (cfr : code s�cante)
            x2 = x1 - y1*(x1-x0)/(y1-y0);
            y2 = f(x2);
            
            %On effectue le m�me algorithme que dans la m�thode de la
            %s�cante sauf qu'on teste � chaque fois si la bissection ne
            %peut pas �tre utilis�e
            while abs(y2) > tolerance && iter<50 && solution == 0
                %Incr�mentation de iter
                iter = iter + 1;
                %Mise � jour des donn�es selon l'algorithme de la m�thode
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
            
            %On v�rifie la cause de sortie de la boucle, si c'est car on a
            %trouv� la racine, on l'indique
            if abs(y2) <= tolerance
                x = x2;
                solution = 1;
            end %fin -if- v�rification mode sortie
            
            %Mise � jour
            test = test + 1;
           
        end %fin -while- global
    end %fin -if- bissection directement utilisable ?  
    
    if test==5
        disp('Impossible to find a root. Our deepest apologies.');
    end %fin -if- a-t-on trouv� qqchose?
    
end %fin fonction


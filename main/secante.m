function [ x ] = secante(f, x0, x1)

    %Condition d'utilisation :
    %1) f(x0) diff�rent de f(x1)
    
    %D�finition d'une variable donnant la tol�rance par rapport au r�sultat
    %attendu, mais aussi par rapport aux conditions initiales (cfr. Rapport).
    tolerance = 1e-7;
    
    %Variable contr�lant l'entr�e/sortie dans/de la boucle
    test = 1;
    
    while(test ~= 0)
        %D�finition d'une variable "garde-fou", pour limiter le nombre
        %d'it�rations maximal.
        iter = 0;
        %Initialisation des donn�es
        y0 = f(x0);
        y1 = f(x1);
        
        %V�rification de la condition 1)
        if abs(y1-y0) < tolerance
            %Si les valeurs initiales sont inad�quates, on demande �
            %l'utilisateur d'en entrer de nouvelles
            disp('Wrong initial values. Please check them.');
            disp('Please choose new ones');
            x0=input('x0: ');
            x1=input('x1: ');
            fprintf('Your new initial values are : %.3f et %.3f\n',x0,x1);
         
        %Si les valeurs initiales sont valides, on continue...
        else
            %On initialise les derni�res variables en fonction de
            %l'algorithme de la m�thode (cfr. Cours th�orique)
            x2 = x1 - y1*(x1-x0)/(y1-y0);
            y2 = f(x2);
            
            %Boucle de l'algorithme en tant que tel. On sort la boucle
            %si la valeur obtenue est suffisamment proche de la racine
            %recherch�e ou si le nombre d'it�rations est trop important
            %(cfr. Ci-dessous et rapport)
            while (abs(y2) > tolerance && iter<50)
                %Incr�mentation de iter
                iter = iter + 1;    
                %Mise � jour des donn�es selon l'algorithme de la m�thode
                x0 = x1;
                y0 = y1;
                x1 = x2;
                y1 = y2;
                x2 = x1 - y1*(x1-x0)/(y1-y0);
                y2 = f(x2);
            end %fin -while- algorithme
    
            %Si la cause de sortie de boucle n'est pas le nombre d'it�ration, la
            %valeur obtenue est la racine recherch�e, � la tol�rance pr�s.
            if iter < 50
                x = x2;
                disp('Root : ');
                disp(x);
                %Pour sortir de la boucle principale, actualisation de
                %test.
                test = 0;
                
            %Sinon, le nombre d'it�rations est fort important et il vaut sans 
            %doute mieux relancer l'algorithme (cfr. Rapport) pour augmenter
            %l'efficacit�. De plus, le probl�me de la m�thode de la s�cante
            %est son manque de robustesse. Si le nombre d'it�rations
            %devient important, il vaut sans doute mieux le relancer avec
            %de nouvelles conditions initiales pour �viter une boucle
            %infinie.
            else
                disp('Unefficient initial values. Please check them.');
                fprintf('Current value of the root : %.3f\n', x2);
                disp('Please choose new ones');
                x0=input('x0: ');
                x1=input('x1: ');
                fprintf('Your new initial values are : %.3f et %.3f\n',x0,x1);
        
            end %fin -if- v�rification du mode de sortie de boucle.
    
        end %fin -if- v�rification de la validit� des donn�es.
        
    end %fin -while- boucle test ("tant que les donn�es ne sont pas valides")
    
end %fin de la fonction.


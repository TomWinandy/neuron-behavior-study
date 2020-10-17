function [ x ] = secante(f, x0, x1)

    %Condition d'utilisation :
    %1) f(x0) différent de f(x1)
    
    %Définition d'une variable donnant la tolérance par rapport au résultat
    %attendu, mais aussi par rapport aux conditions initiales (cfr. Rapport).
    tolerance = 1e-7;
    
    %Variable contrôlant l'entrée/sortie dans/de la boucle
    test = 1;
    
    while(test ~= 0)
        %Définition d'une variable "garde-fou", pour limiter le nombre
        %d'itérations maximal.
        iter = 0;
        %Initialisation des données
        y0 = f(x0);
        y1 = f(x1);
        
        %Vérification de la condition 1)
        if abs(y1-y0) < tolerance
            %Si les valeurs initiales sont inadéquates, on demande à
            %l'utilisateur d'en entrer de nouvelles
            disp('Wrong initial values. Please check them.');
            disp('Please choose new ones');
            x0=input('x0: ');
            x1=input('x1: ');
            fprintf('Your new initial values are : %.3f et %.3f\n',x0,x1);
         
        %Si les valeurs initiales sont valides, on continue...
        else
            %On initialise les dernières variables en fonction de
            %l'algorithme de la méthode (cfr. Cours théorique)
            x2 = x1 - y1*(x1-x0)/(y1-y0);
            y2 = f(x2);
            
            %Boucle de l'algorithme en tant que tel. On sort la boucle
            %si la valeur obtenue est suffisamment proche de la racine
            %recherchée ou si le nombre d'itérations est trop important
            %(cfr. Ci-dessous et rapport)
            while (abs(y2) > tolerance && iter<50)
                %Incrémentation de iter
                iter = iter + 1;    
                %Mise à jour des données selon l'algorithme de la méthode
                x0 = x1;
                y0 = y1;
                x1 = x2;
                y1 = y2;
                x2 = x1 - y1*(x1-x0)/(y1-y0);
                y2 = f(x2);
            end %fin -while- algorithme
    
            %Si la cause de sortie de boucle n'est pas le nombre d'itération, la
            %valeur obtenue est la racine recherchée, à la tolérance près.
            if iter < 50
                x = x2;
                disp('Root : ');
                disp(x);
                %Pour sortir de la boucle principale, actualisation de
                %test.
                test = 0;
                
            %Sinon, le nombre d'itérations est fort important et il vaut sans 
            %doute mieux relancer l'algorithme (cfr. Rapport) pour augmenter
            %l'efficacité. De plus, le problème de la méthode de la sécante
            %est son manque de robustesse. Si le nombre d'itérations
            %devient important, il vaut sans doute mieux le relancer avec
            %de nouvelles conditions initiales pour éviter une boucle
            %infinie.
            else
                disp('Unefficient initial values. Please check them.');
                fprintf('Current value of the root : %.3f\n', x2);
                disp('Please choose new ones');
                x0=input('x0: ');
                x1=input('x1: ');
                fprintf('Your new initial values are : %.3f et %.3f\n',x0,x1);
        
            end %fin -if- vérification du mode de sortie de boucle.
    
        end %fin -if- vérification de la validité des données.
        
    end %fin -while- boucle test ("tant que les données ne sont pas valides")
    
end %fin de la fonction.


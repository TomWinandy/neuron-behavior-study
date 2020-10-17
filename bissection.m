function [ x ] = bissection(f, x0 , x1)
    
    %Conditions d'utilisation :
    % 1) Fonction continue (pas vérifié dans ce code)
    % 2) y0 et y1 de signe contraire
    
    %Définition d'une variable donnant la tolérance par rapport au résultat
    %attendu (cfr. Rapport).
    tolerance = 2 * 1e-7;

    %Définition d'une variable permettant de gérer l'entrée/sortie dans la
    %boucle
    error = 1;
    
    %On boucle tant que la condition 2 n'est pas respectée 
    while(error==1)
        %Initialisation des données
        y0 = f(x0);
        y1 = f(x1);

        %Test de la validité de la condition 2
        if y0*y1 > 0
            disp('ERROR : The initial values are supposed to have images by the function of opposite signs');
            disp('Please, try with other initial values');
            %Lecture au clavier des nouvelles valeurs de départ
            x0 = input('x0 = ');
            x1 = input('x1 = ');

        %Si les données initiales sont valides, on continue...   
        else 
            %Afin de sortir de la boucle while on actualise error
            error = 0;

            %Afin d'optimiser l'algorithme, on s'arrange pour que y0
            %soit toujours négatif et y1 positif. Dès lors, puisqu'ils
            %sont de signe opposé, il suffit de vérifier le signe de
            %l'un, i.e. y0, et d'actualiser les données "au cas où".
            if y0 > 0
                %swap des abscisses
                tmp = x0;
                x0 = x1;
                x1 = tmp;
            end %fin -if- vérification signe y0

            %Dès lors, on a donc f(x0) négatif (ou nul) et f(x1) positif

            %Initialisation des données restantes
            x2 = (x0 + x1)/2;
            y2 = f(x2);

            %Boucle de l'algorithme en tant que tel
            while abs(x1-x0)>tolerance
                %Il existe un autre possibilité de sortir de la boucle
                %(cfr. Rapport)
      
                %Test du signe de y2; adaptation de (x0,y0) ou (x1,y1)
                if y2 <= 0 
                    %Dans ce cas, x2 devient la valeur "à ordonnée 
                    %négative", i.e. x0. Le cas = 0 nous prémunit par 
                    %exemple du fait que y2 pourrait être très proche 
                    %de 0, à une distance plus petite que l'epsilon 
                    % machine, et serait donc arrondi de manière
                    %erronée à 0. (Mais aussi du fait que dans la question
                    %3.2 du projet, Iapp ne sera jamais négatif)
                    x0 = x2;
               
                else
                    %Si y2>0, x2 devient la valeur "à
                    %ordonnée positive", i.e. x1
                    x1 = x2;

                end %fin -if- test signe y2

                %Mise à jour
                x2 = (x0 + x1)/2;
                y2 = f(x2);

            end %fin -while- algorithme

            %On est assuré que la racine appartient à l'intervalle 
            %[x0,x1], dont la taille est inférieure à la tolérance. La
            %valeur de x2 courante est la meilleure approximation de la
            %racine compte tenu de cette tolérance               
            fprintf('The root you are looking for lies between %f and %f\n', x0, x1);
            disp('Its value is');
            disp(x2);
            x = x2;

        end %fin -if- validité donnée

    end %fin -while- général "tant que les données ne sont pas valides"

end %fin de la fonction

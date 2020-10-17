function [ I_app_final, temps_I_app_final ] = creation_vecteurs_I_app( duree_impulsion, periode, I_app )
    %I_app est un vecteur du genre [x0, x1,..., xk], cad, traduisant que
    %toutes les "periodes" ms, on envoie un couranr de "duree_impulsion" ms
    %et d'intensité xi, i appartenant à {0, 1, ..., k}. Ainsi, entre la
    %i*periode eme ms et la i*periode+duree_impulsion eme ms, le neurone
    %est soumis à une intensité xi
    %Nous souhaitons avoir en sortie un vecteur I_app_final de la forme
    %[x0, x0, 0, 0, x1, x1, 0, 0,..., xk, xk, 0, 0], et temps_I_app_final
    %de la forme [0, duree_impulsion-ecart, duree_impulsion, periode-ecart,
    %periode, periode+duree_impulsion-ecart, periode+duree_impulsion,
    %2*periode-ecart,..., k*periode, k*periode+duree_impulsion-ecart, 
    %k*periode+duree_impulsion, (k+1)*periode-ecart]
    
    %Initialisation de I_app_final et temps_I_app_final. Leur longueur se
    %déduit aisément du commentaire ci-dessus
    I_app_final = zeros((length(I_app) * 4), 1);
    temps_I_app_final = zeros(length(I_app_final), 1);
    
    %Définition d'un ecart entre l'instant correspondant à un I_app xi et
    %le courant nul qui le suit (pour l'interpolation, on ne peut avoir 2
    %"y" (i.e. courant) pour un même "x" (i.e. temps))
    ecart = 0.001;
    
    %Initialisation d'un compteur pour Iapp
    j=1;
    
    %On boucle par bloc de 4 valeurs pour créer un I_app_final de la forme
    %souhaitée, càd répondant au critère de constant par morceau et nul
    %entre deux impulsions successives (cfr. commentaire ci-dessus)
    for i=1:4:length(I_app_final)-3
        %Remplissage de I_app_final
        I_app_final(i) = I_app(j);
        I_app_final(i+1) = I_app(j);
        I_app_final(i+2) = 0;
        I_app_final(i+3)= 0;
        
        %Remplissage de temps_I_app_final
        %On remarquera l'utilisation d'ecart, comme expliqué ci-dessus
        temps_I_app_final(i) = (j-1)*periode;
        temps_I_app_final(i+1) = (j-1)*periode + duree_impulsion - ecart;
        temps_I_app_final(i+2) = (j-1)*periode + duree_impulsion;
        temps_I_app_final(i+3) = j*periode - ecart;
        
        %Mise à jour du compteur
        j=j+1;
        
        %On aura donc, par exemple, si periode = 100, duree_impulsion = 20
        %et I_app = [0 1 2]
        %I_app_final = [0 0 0 0 1 1 0 0 2 2 0 0] et
        %temps_I_app_final = [0 19.999 20 99.999 100 119.999 120 199.999
        %200 219.999 220 299.999]
    end
end

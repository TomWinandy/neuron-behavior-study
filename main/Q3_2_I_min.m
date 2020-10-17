function [ I_min ] = Q3_2_I_min( freq )
    
    %Le script frequence_fct_de_i_app nous a permis de déterminer la
    %frequence maximale qui pouvait être produite et la valeur de Iapp
    %correspondante (resp. 43.501 et 1.76) (cfr.Rapport)
    %Si la fréquence demandée par l'utilisateur excède cette fréquence
    %maximale, elle ne pourra donc pas être atteinte
    freq_max = 44.5103;
     
    if freq > freq_max
        disp('There isn''t t any intensity which leads to this frequency of spikes.')
    
    %Si la fréquence demandée est inférieure, on peut l'atteindre, et ce
    %grâce à la méthode de la bissection avec pour valeurs initiales un I
    %dont la fréquence associée est minimale (i.e. 0.1, comme vu en
    %question 2.2) et le I dont la fréquence associée est maximale (i.e.
    %1.69) (cfr. Rapport)
    else
        
        I_freq_nulle = 0.1;
        I_freq_sup = 1.735; 
        I_min= bissection(@(Iapp)simulation_neurone(Iapp)-freq, I_freq_nulle, I_freq_sup);
    end

end


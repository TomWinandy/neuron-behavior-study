function [ I_min ] = Q3_2_I_min( freq )
    
    %Le script frequence_fct_de_i_app nous a permis de d�terminer la
    %frequence maximale qui pouvait �tre produite et la valeur de Iapp
    %correspondante (resp. 43.501 et 1.76) (cfr.Rapport)
    %Si la fr�quence demand�e par l'utilisateur exc�de cette fr�quence
    %maximale, elle ne pourra donc pas �tre atteinte
    freq_max = 44.5103;
     
    if freq > freq_max
        disp('There isn''t t any intensity which leads to this frequency of spikes.')
    
    %Si la fr�quence demand�e est inf�rieure, on peut l'atteindre, et ce
    %gr�ce � la m�thode de la bissection avec pour valeurs initiales un I
    %dont la fr�quence associ�e est minimale (i.e. 0.1, comme vu en
    %question 2.2) et le I dont la fr�quence associ�e est maximale (i.e.
    %1.69) (cfr. Rapport)
    else
        
        I_freq_nulle = 0.1;
        I_freq_sup = 1.735; 
        I_min= bissection(@(Iapp)simulation_neurone(Iapp)-freq, I_freq_nulle, I_freq_sup);
    end

end


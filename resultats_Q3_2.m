%Script servant à l'obtention de résultats pour la question 3.2 (cfr.
%Rapport)

j = 1;
resultats = zeros(18,1);
frequence = zeros(18,1);
for i = 0: 4 : 20
    frequence(j) =i;
    resultats(j) = Q3_2_I_min(i);
    j = j+1;
end

for i = 22 : 2 : 44
    frequence(j) =i;
    resultats(j) = Q3_2_I_min(i);
    j = j+1;
end
    
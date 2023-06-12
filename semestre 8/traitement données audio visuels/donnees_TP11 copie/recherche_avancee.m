function [resultats] = recherche_avancee(identifiants, instants, bdd)
   resultats=[];
   for i= 1:length(identifiants)
         if bdd.isKey(identifiants(i))
             morceau = bdd(identifiants(i));
             morceau_numero = morceau(:,2);
             morceau_instants = morceau(:,1);
             diffs_temporelles = instants(i) - morceau_instants;
             for j=1:length(morceau_numero)
                resultats=[resultats; morceau_numero(j), diffs_temporelles(j)];
             end
         end
   end
end

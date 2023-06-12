function [resultats] = recherche_simplifiee(identifiants, bdd)
   resultats=[];
   for i= 1:length(identifiants)
         if bdd.isKey(identifiants(i))
             morceau=bdd(identifiants(i));
             morceau= morceau(:,2);
             resultats=[resultats,morceau'];
         end
   end
   resultats=resultats';






    




function resultats = recherche_simplifiee_triplet(identifiants, bdd)
     resultats = [];
    for i = 1:length(identifiants)
        if bdd.isKey(identifiants(i))
            triplet = bdd(identifiants(i));
            triplet = triplet(:,2);
            resultats = [resultats, triplet'];
        end
    end
    resultats = resultats';
end

function res= max_vraisemblance(D_app,parametres)
%nombre de points et d'ellipse
np = size(parametres, 1);
valeur_max= zeros(np, 1);
for i = 1:np
    parametres_en_cours = parametres(i, :);
    r = calcul_r(D_app, parametres_en_cours);
    s = sum(r.^2);
    valeur_max(i) = s;
end
  [~, id_max]= min(valeur_max);
  res= parametres(id_max, :);
end
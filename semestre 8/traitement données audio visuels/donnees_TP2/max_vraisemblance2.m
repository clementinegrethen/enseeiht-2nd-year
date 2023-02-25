function res = max_vraisemblance_2(D_app,parametres_test,sigma);
%nombre de points et d'ellipse
np = size(parametres_test, 1);
valeur_max= zeros(np, 1);
for i = 1:np
    parametres_1 = parametres_test(i, 1, :);
    parametres_2 = parametres_test(i, 2, :);
    r1 = calcul_r(D_app, parametres_1);
    r2= calcul_r(D_app,parametres_2);
    ps1 = 0.5 / sigma;
    ps2 = 0.5 / sigma;
    lr = log(ps1 * exp(-r1.^2 / (2 * sigma^2)) + ps2 * exp(-r2.^2 / (2 * sigma^2)));
    s = sum(r);
    valeur_max(i) = s;
end
  [~, id_max]= min(valeur_max);
  res= parametres(id_max, :);
end
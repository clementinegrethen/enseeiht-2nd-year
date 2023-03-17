function res = max_vraisemblance_2(D_app,parametres_test,sigma);
%nombre de points et d'ellipse
n = size(parametres_test, 1);
valeur_max= zeros(n, 1);
for i = 1:n
    parametres_1 = parametres_test(i, 1, :);
    parametres_2 = parametres_test(i, 2, :);
    r1 = calcul_r(D_app, parametres_1);
    r2= calcul_r(D_app,parametres_2);
    ps1 = 0.5 / sigma;
    ps2 = 0.5 / sigma;
    s = sum(log(ps1 * exp(-r1.^2 / (2 * sigma^2)) + ps2 * exp(-r2.^2 / (2 * sigma^2))));
    valeur_max(i) = s;
end
  [x, id_max]= max(valeur_max);
  res= parametres_test(id_max, :);
end
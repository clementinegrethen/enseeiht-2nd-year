function probas = probabilites_EM(D_app,parametres_estim,proportion_1,proportion_2,sigma)
% variables et calculs intermédiaires
    np = size(parametres_estim, 1);
    parametres_1 = parametres_estim(1, :);
    parametres_2 = parametres_estim(2, :);
    r1 = calcul_r(D_app, parametres_1);
    r2= calcul_r(D_app,parametres_2);
    % dénominateur dans le calcul:
    deno = (proportion_1 / sigma) * exp(- r1.^2 / (2 * sigma^2)) + (proportion_2 / sigma) * exp(- r2.^2 / (2 * sigma^2));
    % calcul de proba :
    probas=[(proportion_1 / sigma) * exp(- r1.^2 / (2 * sigma^2)) ./ deno;(proportion_2 / sigma) * exp(- r2.^2 / (2 * sigma^2)) ./ deno]
end


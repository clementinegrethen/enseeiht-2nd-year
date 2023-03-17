function probas = probabilites(D_app,parametres_estim,sigma)
% variables et calculs intermédiaires
% pi vaut 0.5 dans le sujet 
    parametres_1 = parametres_estim(1, :);
    parametres_2 = parametres_estim(2, :);
    r1 = calcul_r(D_app, parametres_1);
    r2= calcul_r(D_app,parametres_2);
    ps = 0.5 / (sigma*sqrt(2*pi));
    int1 = ps*(exp(-(r1.^2)/(2*(sigma)^2)));
    int2 = ps*(exp(-(r2.^2)/(2*(sigma)^2)));
    % calcul de proba :
    probas=[int1;int2];
end


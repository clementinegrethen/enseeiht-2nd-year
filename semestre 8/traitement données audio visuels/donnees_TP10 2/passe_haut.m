
function [Y_modifie] = passe_bas(Y, valeurs_f, f_coupure)
    % Trouver l'indice correspondant à la fréquence de coupure
    indice_coupure = find(valeurs_f > f_coupure, 1);
    
    % Mettre à zéro les coefficients au-dessus de la fréquence de coupure
    Y_modifie = Y;
    Y_modifie(1:indice_coupure-1, :) = 0;
end

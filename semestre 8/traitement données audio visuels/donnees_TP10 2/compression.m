function [Y_modifie] = compression(Y, m)
    % Calculer la taille du sonagramme
    [n_lignes, n_colonnes] = size(Y);
    
    % Initialiser le sonagramme modifié
    Y_modifie = zeros(n_lignes, n_colonnes);
    
    % Appliquer la compression pour chaque colonne
    for col = 1:n_colonnes
        % Obtenir les coefficients de Fourier en module
        module = abs(Y(:, col));
        
        % Sélectionner les m coefficients les plus élevés
        [top_module, indices] = maxk(module, m);
        
        % Mettre à jour la colonne du sonagramme modifié avec les coefficients conservés
        Y_modifie(indices, col) = Y(indices, col);
    end
end

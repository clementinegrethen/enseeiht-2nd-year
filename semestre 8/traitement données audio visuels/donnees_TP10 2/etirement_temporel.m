


function [y_modifie] =  etirement_temporel(y, f_ech, pourcentage_acceleration)
    n_fenetre = 2048;		% Largeur de la fenêtre (en nombre d'échantillons)
    n_decalage = 512;		% Décalage entre positions successives de la fenêtre (en nombre d'échantillons)
    fenetre = 'hann';		% Type de la fenêtre : 'rect' ou 'hann'
    Y=TFCT(y,f_ech,n_fenetre,n_decalage,fenetre);    
    C = 1:pourcentage_acceleration:size(Y, 2);
    phi = angle(Y(:, 1));
    Y_prime = zeros(size(Y));
    
    for i = 1:length(C)
        c = floor(C(i));
        alpha = C(i) - c;
        rho = (1 - alpha) * Y(:, c) + alpha * Y(:, c + 1);
        Y_prime(:, c) = rho .* exp(1i * phi);
        dphi = angle(Y(:, c + 1)) - angle(Y(:, c));
        phi = phi + dphi;
    end
    
   [y_modifie, ~] = ITFCT(Y_prime, f_ech, n_decalage, 'rect');
    y_modifie = real(y_modifie); % Conversion en signal temporel réel (élimine les parties imaginaires)
    y_modifie = resample(y_modifie, f_ech, round(f_ech * pourcentage_acceleration)); % Rééchantillonnage pour compenser l'étirement temporel
   	%y_modifie = resample(y_modifie, f_ech, round(f_ech * pourcentage));
%y_modifie = y_modifie / max(abs(y_modifie));
    
    end     



   



    






    

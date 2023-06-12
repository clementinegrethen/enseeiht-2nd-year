function [y, valeurs_t] = ITFCT(Y, f_ech, n_decalage, fenetre)

	% ITFCT (inverse de la transformée de Fourier à court terme)
	% Par Overlap - Add
	%	
	% Inputs :
	%	Y			: TFCT d'un signal réel
	%	f_ech		: fréquence d'échantillonage
	%	n_decalage	: taille entre deux fenêtres
	%	fenetre		: type de fenêtre
	%
	% Outputs :
	%	y			: ITFCT(Y)
	%	valeurs_t	: points temporels

	% On retrouve la taille de la fenêtre d'origine
	% (on a enlevé presque la moitié des valeurs) :
	n_fenetre = (size(Y, 1) - 1) * 2;

	% On redonne la bonne taille à Y (pas besoin de remettre les bons coefficients,
	% la fonction ifft de Matlab gère pour nous) :
	Y(size(Y, 1) + 1:n_fenetre, :) = 0;

	% Récupération de la fenêtre utilisée :
	switch fenetre
	case 'rect'
		w = ones(n_fenetre, 1);
	otherwise
		w = hann(n_fenetre);
	end

	% Création d'un signal vierge et d'une variable permettant de calculer la somme des fenêtres :
	n = (size(Y, 2) + 1) * n_decalage;
	y = zeros(n, 1);
	w_sum = zeros(n, 1);

	for valeurs_t = 1:size(Y,2)
		% On retrouve le signal fenêtré (l'option 'symmetric' indique à
		% Matlab d'utiliser la symétrie hermitienne de la TFCT d'un signal réel) :
		y_win = ifft(Y(:, valeurs_t), 'symmetric');
		
		% On ajoute ce tronçon de signal fenêtré au signal,
		% et la fenêtre à la somme des fenêtres :
		start = 1 + (valeurs_t-1)*n_decalage;
		y(start : start + n_fenetre - 1) = y(start : start + n_fenetre - 1) + y_win;
		w_sum(start : start + n_fenetre - 1) = w_sum(start : start + n_fenetre - 1) + w;
	end

	% On dé-fenêtre (en évitant de diviser par 0) :
	y = y ./ (w_sum + eps);

	% Calcul des valeurs temporelles correspondant à chaque point du signal :
	valeurs_t = (0:length(y)-1) / f_ech;
end


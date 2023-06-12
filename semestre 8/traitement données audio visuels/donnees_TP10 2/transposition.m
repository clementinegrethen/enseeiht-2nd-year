function [y_transpose] = transposition(y, f_ech, pourcentage)

	% Transposition
	%	
	% Inputs :
	%	y					: signal réel
	%	f_ech				: fréquence d'échantillonage de y
	%	pourcentage			: pourcentage de modification de la hauteur (200% = 2x plus aigu (440Hz -> 880Hz))
	%
	% Outputs :
	%	y_modifie			: signal modifié

	% Change le contenu fréquentiel d'un signal sans altérer sa durée

	% Si l'on veut un signal 2x plus aigu :
	% il suffit de le rallonger d'un facteur 2 (étirement x0.5)...
	y_etire = etirement_temporel(y, f_ech, 1/pourcentage);

	% ... puis le lire 2x plus rapidement
	y_transpose = changement_vitesse(y_etire, f_ech, pourcentage);
	% y_transpose = resample(y_etire, f_ech, round(pourcentage * f_ech));

end
function y_modifie = changement_vitesse(y, f_ech, pourcentage)

	% Changement de vitesse de lecture
	%	
	% Inputs :
	%	y					: signal réel
	%	f_ech				: fréquence d'échantillonage de y
	%	pourcentage			: pourcentage de modification de la vitesse de lecture (200% = 2x plus vite)
	%
	% Outputs :
	%	y_modifie			: signal modifié

	% Simule un changement de vitesse de lecture en ré-échantillonant le signal

	y_modifie = resample(y, f_ech, round(f_ech * pourcentage));
	
end
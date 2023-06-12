function [y,debut_extrait] = extrait(y, f_ech, duree_extrait)

	% Découpage d'un extrait de duree_extrait secondes dans y
	%	
	% Inputs :
	%	y					: signal audio
	%	f_ech				: sa fréquence d'échantillonage
	%	duree_extrait		: durée de l'extrait souhaitée en secondes
	%
	% Outputs :
	%	y					: extrait de y de duree_extrait secondes

	debut_extrait = randi(length(y) - f_ech*duree_extrait + 1);
	y = y(debut_extrait : debut_extrait + f_ech*duree_extrait - 1);
end
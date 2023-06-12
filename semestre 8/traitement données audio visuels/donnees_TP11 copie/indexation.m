function identifiants = indexation(paires)

	% Calcul de l'identifiant d'une paire
	%	
	% Inputs :
	%	paires				: tableau des appariements, chaque ligne étant de la forme [f_1, f_2, t_1, t_2]
	%
	% Outputs :
	%	identifiants		: tableau des identifiants, chaque ligne contenant l'identifiant de la paire associée dans paires

	f1 = rem(paires(:,1)-1, 2^8);
	f2 = rem(paires(:,2)-1, 2^8);
	t21 = rem(paires(:,4) - paires(:,3), 2^16);
	identifiants = uint32(f1*2^24 + f2*2^16 + t21);
end

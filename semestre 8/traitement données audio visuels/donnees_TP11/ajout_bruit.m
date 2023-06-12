function y = ajout_bruit(y, y_bruit, SNR)

	% Ajout d'un signal de bruit à un signal
	%	
	% Inputs :
	%	y					: signal
	%	y_bruit				: signal de bruit
	%	SNR					: rapport signal sur bruit (rapport de l'energie de y sur l'energie de y_bruit)
	%
	% Outputs :
	%	y					: signal bruité

	E_y = sum(y.^2);
	E_bruit = sum(y_bruit.^2);
	rapport = sqrt(E_y / (E_bruit*SNR));
	y = y + rapport*y_bruit;
	y = y/max(y);

end
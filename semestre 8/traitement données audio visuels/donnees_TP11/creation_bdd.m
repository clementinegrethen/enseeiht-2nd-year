clear;
close all;

% Chargement des paramètres (voir parametres.m)
load parametres;

bdd = containers.Map('KeyType','uint32','ValueType','any');

for id = 1:length(fichiers)

	% Lecture d'un fichier audio :
	disp(fichiers(id).name);
	[y, f_ech] = audioread(chemin_reechantillone + fichiers(id).name);
	y = mean(y, 2);

	% Calcul du sonagramme :
	[Y, valeurs_t, valeurs_f] = TFCT(y, f_ech, n_fenetre, n_decalage, fenetre);
	S = 20*log10(abs(Y)+eps);

	% Calcul des pics spectraux :
	[pics_t, pics_f] = pics_spectraux(S, eta_t, eta_f, epsilon);

	% Calcul des paires de pics spectraux :
	paires = appariement(pics_t, pics_f, n_v, delta_t, delta_f);

	% Calcul des identifiants :
	identifiants = indexation(paires);

	% Stockage des identifiants :
	for i = 1:length(identifiants)
		identifiant = identifiants(i);
		entree = [paires(i,3) id];
		if bdd.isKey(identifiant)
			bdd(identifiant) = [bdd(identifiant) ; entree];
        else
			bdd(identifiant) = [entree];
		end
	end
end

save bdd.mat bdd;

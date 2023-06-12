clear;
close all;

% Chargement des paramètres (voir parametres.m)
load parametres;

% Chargement de la base de données :
load bdd;

% Paramètres :
duree_extrait = 10;		% Durée des extraits (en secondes)
N_tests = 100;			% Nombre de tests
SNR = 1;				% Rapport signal sur bruit

[y_bruit_parole, ~] = audioread('Morceaux/talking.mp3');

nb_reconnus = 0;
f = waitbar(0,'Starting');
for i = 1:N_tests

	% Lecture d'un fichier audio tiré aléatoirement :
	numero_morceau = randi(length(fichiers));
	[y, f_ech] = audioread(chemin_reechantillone + fichiers(numero_morceau).name);
	y=changement_vitesse(y,f_ech,1.5);

	% Extrait de durée variable, tiré aléatoirement :
	debut_extrait = randi(length(y) - f_ech*duree_extrait + 1);
	y = y(debut_extrait : debut_extrait + f_ech*duree_extrait - 1);


% 	% Ajout du bruit (blanc et/ou de parole) :
	 %y = ajout_bruit(y, randn(size(y)), SNR);
	 %y = ajout_bruit(y, extrait(y_bruit_parole, f_ech, duree_extrait), SNR);

    % Création d'un bruit (blanc, rose ou marron) :
%     type_de_bruit = 'blanc'; % Choisissez parmi 'blanc', 'rose' ou 'marron'
%     
%     switch type_de_bruit
%         case 'blanc'
%             y_bruit = randn(size(y));
%         case 'rose'
%             y_bruit = dsp.ColoredNoise('Color','pink','SamplesPerFrame',length(y));
%             y_bruit = y_bruit();
%         case 'marron'
%             y_bruit = dsp.ColoredNoise('Color','brown','SamplesPerFrame',length(y));
%             y_bruit = y_bruit();
%         otherwise
%             error('Type de bruit inconnu. Choisissez parmi ''blanc'', ''rose'' ou ''marron''.')
%     end
%         y = ajout_bruit(y, y_bruit, SNR);


	% Calcul du sonagramme :
	[Y,valeurs_t,valeurs_f] = TFCT(y, f_ech, n_fenetre, n_decalage, fenetre);
	S = 20*log10(abs(Y)+eps);

	% Calcul des pics spectraux :
	[pics_t, pics_f] = pics_spectraux(S, eta_t, eta_f, epsilon);

	% Calcul des paires de pics spectraux :
	paires = appariement(pics_t, pics_f, n_v, delta_t, delta_f);

	if length(paires) < 5
		nb_reconnus = nb_reconnus+1;
		continue;
	end

	% Calcul des identifiants :
	identifiants = indexation(paires);

	% Comparaison des identifiants :
	%resultats = recherche_simplifiee(identifiants, bdd);
    
	resultats = recherche_avancee(identifiants, paires(:,3), bdd);

	if length(resultats)<1
		continue;
    end

    [C,ia,ic] = unique(resultats,'rows','stable');
    h = accumarray(ic,1);
    [m,ind] = max(h);
    numero_reconnu = C(ind,1);
    
	if numero_reconnu==numero_morceau
		nb_reconnus = nb_reconnus+1;
	end
	waitbar(i/N_tests,f,sprintf('Progress: %d %%',floor(i/N_tests*100)));
end

fprintf('Precision : %4.1f %% \n',nb_reconnus/N_tests*100);

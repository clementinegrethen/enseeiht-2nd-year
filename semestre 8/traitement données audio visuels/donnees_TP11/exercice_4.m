clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Chargement des paramètres (voir parametres.m)
load parametres;

% Chargement de la base de données :
load bdd;

% Lecture d'un fichier audio tiré aléatoirement :
numero_morceau = randi(length(fichiers));
[y, f_ech] = audioread(chemin + fichiers(numero_morceau).name);

% Extrait de durée duree_extrait, tiré aléatoirement :
duree_extrait = 1;
y = extrait(y, f_ech, duree_extrait);

% Création d'un bruit (blanc ou de parole) :
y_bruit_blanc = randn(size(y));
[y_bruit_parole, ~] = audioread('Morceaux/talking.mp3');
y_bruit_parole = extrait(y_bruit_parole, f_ech, duree_extrait);

% Ajout du bruit (blanc et/ou de parole) :
SNR = 1;			% Rapport signal sur bruit
% y = ajout_bruit(y, y_bruit_blanc, SNR);
% y = ajout_bruit(y, y_bruit_parole, SNR);

% Lecture de l'extrait à reconnaître
sound(y, f_ech);
pause(duree_extrait);

% Ré-échantillonage à 2*f_max
y = resample(y, 2*f_max, f_ech);
f_ech = 2*f_max;

% Calcul du sonagramme :
[Y,valeurs_t,valeurs_f] = TFCT(y, f_ech, n_fenetre, n_decalage, fenetre);
S = 20*log10(abs(Y)+eps);

% Calcul des pics spectraux :
[pics_t, pics_f] = pics_spectraux(S, eta_t, eta_f, epsilon);

% Calcul des paires de pics spectraux :
paires = appariement(pics_t, pics_f, n_v, delta_t, delta_f);

% Calcul des identifiants :
identifiants = indexation(paires);

% Récupération des empreintes présentes dans la base de données :
	resultats = recherche_avancee(identifiants, paires(:,3), bdd);

% 
%Recherche du meilleur résultat :
[C,ia,ic] = unique(resultats,'rows','stable');
h = accumarray(ic,1);
[m,ind] = max(h);
numero_reconnu = C(ind,1);
%numero_reconnu2= mode(resultats);

if numero_reconnu==numero_morceau
	fprintf('Le morceau "%s" a ete correctement reconnu !\n',fichiers(numero_morceau).name(1:end-4));
else
	fprintf('Le morceau "%s" n''a pas ete reconnu !\n',fichiers(numero_morceau).name(1:end-4));
end

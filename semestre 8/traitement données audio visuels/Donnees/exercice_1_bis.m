clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% [y, f_ech] = audioread('Musiques/Ed Sheeran-Shape of You.mp3', [40*44100 50*44100]);
% [y, f_ech] = audioread('Musiques/Lizzo-Boys.mp3', [10*44100 20*44100]);
[y, f_ech] = audioread('Musiques/Michael Jackson-Beat it.mp3', [35*44100 55*44100]);

% Passage dans le domaine fréquentiel :
n_fenetre = 1024;		% Largeur de la fenêtre (en nombre de points)
n_decalage = 512;		% Décalage entre deux fenêtres (en nombre de points)
fenetre = 'hann';		% Type de la fenêtre

[Y, valeurs_t, valeurs_f] = TFCT(y,f_ech,n_fenetre,n_decalage,fenetre);
S = 20*log10(abs(Y)+eps);

% Séparation harmonique/percussive :
[F_h, F_p] = HPSS(abs(Y).^2);

% Création des masques :
M_h = F_h ./ (F_h + F_p);
M_p = F_p ./ (F_h + F_p);

% Application des masques :
Y_h_hat = M_h .* Y;
Y_p_hat = M_p .* Y;

% Retour dans le domaine temporel :
[y_h_hat, ~] = ITFCT(Y_h_hat,f_ech,n_decalage,fenetre);
[y_p_hat, ~] = ITFCT(Y_p_hat,f_ech,n_decalage,fenetre);

% Normalisation :
y_h_hat = min(max(y_h_hat,-1),1);
y_p_hat = min(max(y_p_hat,-1),1);

% Sauvegarde :
audiowrite('Resultats/HPSS_harmonique.wav',y_h_hat,f_ech);
audiowrite('Resultats/HPSS_percussive.wav',y_p_hat,f_ech);
audiowrite('Resultats/HPSS_mix.wav',y,f_ech);
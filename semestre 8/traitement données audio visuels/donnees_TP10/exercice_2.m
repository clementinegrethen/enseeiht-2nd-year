clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Lecture d'un fichier audio
[y, f_ech] = audioread('Audio/mpl.wav');
y = mean(y, 2);

% Calcul de la transformée de Fourier à court terme :
n_fenetre = 2048;		% Largeur de la fenêtre (en nombre d'échantillons)
n_decalage = 512;		% Décalage entre positions successives de la fenêtre (en nombre d'échantillons)
fenetre = 'hann';		% Type de la fenêtre : 'rect' ou 'hann'

% Calcul de la TFCT :
[Y, valeurs_t, valeurs_f] = TFCT(y, f_ech, n_fenetre, n_decalage, fenetre);

% Affichage du sonagramme original, en guise de comparaison :
figure(Name='Modification du spectrogramme', Position=[0,0,L,0.6*H]);
subplot(1,2,1);
imagesc(valeurs_t, valeurs_f,20*log10(abs(Y)), [-60, 40]);
axis xy;
set(gca, FontSize=20);
xlabel('Temps ($s$)', Interpreter='Latex', FontSize=30);
xlabel('Frequence ($Hz$)', Interpreter='Latex', FontSize=30);
title('Sonagramme original', FontSize=20);

% Ajout d'un effet
%Y_modifie = passe_bas(Y, valeurs_f, 1000);
Y_modifie = passe_haut(Y, valeurs_f, 1000);
%Y_modifie = compression(Y, 100);

% Affichage de la TFCT reconstituée :
subplot(1,2,2);
imagesc(valeurs_t,valeurs_f,20*log10(abs(Y_modifie) + eps), [-60, 40]);
axis xy;
set(gca, FontSize=20);
xlabel('Temps ($s$)', Interpreter='Latex', FontSize=30);
xlabel('Frequence ($Hz$)', Interpreter='Latex', FontSize=30);
title('Sonagramme de la TFCT reconstitue', FontSize=20);

% Calcul de la transformée de Fourier inverse :
[signal_modifie, ~] = ITFCT(Y_modifie, f_ech, n_decalage, fenetre);

% Lecture
player = audioplayer(signal_modifie, f_ech);

% Animation
h = xline(valeurs_t(1));
player.TimerFcn = {@update player, f_ech, h};
play(player);

function update(obj, event, player, f_ech, h)
	n = player.CurrentSample;
	h.Value = n / f_ech;
end

clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Chargement des paramètres (voir parametres.m)
load parametres;

% Lecture d'un fichier audio :
[y, f_ech] = audioread(chemin_reechantillone + fichiers(4).name);

% Découpage d'un extrait de 15 secondes :
y = y(1:f_ech*15);

% Calcul du sonagramme :
[Y,valeurs_t,valeurs_f] = TFCT(y, 2*f_max, n_fenetre, n_decalage, fenetre);
S = 20*log10(abs(Y)+eps);

% Calcul des pics spectraux :
[pics_t, pics_f] = pics_spectraux(S, eta_t, eta_f, epsilon);
% Affichage du spectrogramme et des pics spectraux :
figure(Name='Pics spectraux', Position=[0.4*L,0,0.6*L,0.6*H]);
imagesc(valeurs_t, valeurs_f, S);
caxis([-40 20]);
hold on;
plot(valeurs_t(pics_t), valeurs_f(pics_f), 'ro', MarkerSize=10, MarkerFaceColor='r', LineWidth=2);
axis xy;
title("Pics spectraux ($\eta_t = " + eta_t + "$, $\eta_f = " + eta_f + "$)", Interpreter='Latex')
set(gca, FontSize=20);
xlabel('Temps ($s$)', Interpreter='Latex', FontSize=30);
ylabel('Frequence ($Hz$)', Interpreter='Latex', FontSize=30);

% i = 66;
% rectangle('Position', [valeurs_t(pics_t(i)) - 1/2, valeurs_f(pics_f(i)) - 500/2, 2/2, 1000/2], ...
% 'FaceColor', [1, 0, 0, 0.5], ...
% 'EdgeColor', [1, 0, 0, 0.5]);
% rectangle('Position', [valeurs_t(pics_t(i)), valeurs_f(pics_f(i)) - 3*500/2, 3*2/2, 3*1000/2], ...
% 'FaceColor', [0, 1, 0, 0.6], ...
% 'EdgeColor', [0, 1, 0, 0.6]);

drawnow;

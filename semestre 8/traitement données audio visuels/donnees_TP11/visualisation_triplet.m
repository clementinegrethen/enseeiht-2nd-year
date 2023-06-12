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

% Calcul des triplets de pics spectraux :
triplets = appariement_Triplets(pics_t, pics_f, n_v, delta_t, delta_f);

% Affichage du spectrogramme et des triplets de pics spectraux :
figure('Name', 'Triplets de pics spectraux', 'Position', [0.4*L, 0, 0.6*L, 0.6*H]);
imagesc(valeurs_t, valeurs_f, S, 'AlphaData', 0.5);
caxis([-40 20]);

anchor = 0;
for i = 1:size(triplets, 1)
    hold on;
    if anchor ~= triplets(i, 1)
        anchor = triplets(i, 1);
        color = [rand(), rand(), rand(), 1];
    end
    plot([valeurs_t(triplets(i, 4)), valeurs_t(triplets(i, 5)), valeurs_t(triplets(i, 6))], [valeurs_f(triplets(i, 1)), valeurs_f(triplets(i, 2)), valeurs_f(triplets(i, 3))], 'Color', color, 'LineWidth', 1);
end

hold on;
plot(valeurs_t(pics_t), valeurs_f(pics_f), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', 'LineWidth', 2);
axis xy;
title('Triplets de pics spectraux', 'Interpreter', 'Latex');
set(gca, 'FontSize', 20);
xlabel('Temps ($s$)', 'Interpreter', 'Latex', 'FontSize', 30);
ylabel('Fréquence ($Hz$)', 'Interpreter', 'Latex', 'FontSize', 30);
drawnow;

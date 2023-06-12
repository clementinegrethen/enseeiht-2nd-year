clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Lecture d'un fichier audio
[y, f_ech] = audioread('Audio/audible.wav');
y = mean(y, 2);

% Calcul de la transformée de Fourier à court terme :
n_fenetre = 2048;		% Largeur de la fenêtre (en nombre d'échantillons)
n_decalage = 512;		% Décalage entre positions successives de la fenêtre (en nombre d'échantillons)
fenetre = 'hann';		% Type de la fenêtre : 'rect' ou 'hann'

[Y, valeurs_t, valeurs_f] = TFCT(y, f_ech, n_fenetre, n_decalage, fenetre);
S = 20 * log10(abs(Y) + eps);

% Affichage du module de la transformée de Fourier à court terme :
figure(Name='Transformée de  Fourier à court terme', Position=[0.4*L,0,0.6*L,0.6*H]);
imagesc(valeurs_t, valeurs_f, S);
axis xy;
set(gca, FontSize=20);
xlabel('Temps ($s$)', Interpreter='Latex', FontSize=30);
ylabel('Frequence ($Hz$)', Interpreter='Latex', FontSize=30);

% Calcul de la transformée de Fourier inverse :
[signal_restitue, ~] = ITFCT(abs(Y), f_ech, n_decalage, fenetre);

% Lecture
player = audioplayer(signal_restitue, f_ech);

% Animation
h = xline(valeurs_t(1));
player.TimerFcn = {@update player, f_ech, h};
play(player);

function update(obj, event, player, f_ech, h)
	n = player.CurrentSample;
	h.Value = n / f_ech;
end

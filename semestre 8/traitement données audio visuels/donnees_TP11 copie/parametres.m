clear all;

% Chemin vers les morceaux
chemin = "./Morceaux_8khz/";
chemin_reechantillone =  "./Morceaux_8khz/";
fichiers = dir(chemin_reechantillone + "*.wav");

% Fréquence max
f_max = 4000;

% Paramètres de la TFCT:
n_fenetre = 512;		% Largeur de la fenêtre (en nombre de points)
n_decalage = 256;		% Décalage entre deux fenêtres (en nombre de points)
fenetre = 'hann';		% Type de la fenêtre

% Paramètres du calcul des pics :
eta_t = 30;
eta_f = 30;
epsilon = 1;

% Paramètres du calcul des appariements :
n_v = 5;
delta_t = 90;
delta_f = 90;

save parametres;
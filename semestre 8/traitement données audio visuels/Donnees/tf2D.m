clear;
close all;

% Paramètres de la TFCT
fenetre = 'hann';
n_fenetre = 1024;  % taille de la fenêtre
n_decalage = 512;  % décalage entre les fenêtres

% Lecture du fichier audio
% [y, f_ech] = audioread('Musiques/Lizzo-Boys.mp3');
% Lecture des fichiers séparés :
[y_h, f_ech] = audioread('Musiques/violon.wav');
[y_p, f_ech] = audioread('Musiques/batterie.wav');

% Création du mélange :
taille = min(length(y_h), length(y_p));
y_h = y_h(1:taille);
y_p = y_p(1:taille);
y = y_h + y_p;

% Affichage des signaux audio
figure;
subplot(3,1,1);
plot(y_h);
title('Signal audio - violon');
subplot(3,1,2);
plot(y_p);
title('Signal audio - batterie');
subplot(3,1,3);
plot(y);
title('Signal audio - mélange');

% Calcul de la TFCT
[Y,valeurs_t,valeurs_f] = TFCT(y,f_ech,n_fenetre,n_decalage,fenetre);
S = 20*log10(abs(Y)+eps);


% Affichage du sonagramme
figure;
imagesc(valeurs_t,valeurs_f,S);

title('Sonagramme');
xlabel('Temps');
ylabel('Fréquence');

% Calcul de la TF2D
TF2D = fft2(S);
TF2D = fftshift(TF2D);			% Permet de positionner l'origine (0,0) au centre

% Affichage de la TF2D
figure;
imagesc(abs(TF2D));
title('Transformation de Fourier 2D');
xlabel('Fréquence');
ylabel('Temps');

% Recherche des pics dans la TF2D
[~,locs] = findpeaks(abs(TF2D(:)));

% Association des pics à différentes sources
R = 2; % nombre de sources
source_assignment = kmeans(locs, R);

% Reconstruction et sauvegarde de chaque source
for r = 1:R
    TF2D_r = zeros(size(TF2D));
    TF2D_r(locs(source_assignment==r)) = TF2D(locs(source_assignment==r));  % copier seulement les pics associés à cette source
    S_r = abs(ifft2(TF2D_r));  % récupérer le sonagramme de la source
    Y_r = S_r .* exp(1i*angle(Y));  % reprendre la phase du sonagramme original
    [y_r,~] = ITFCT(Y_r,f_ech,n_decalage,fenetre);
    audiowrite(['Resultats/source_' num2str(r) '.wav'],y_r,f_ech);

    % Affichage du signal audio décomposé
    figure;
    plot(y_r);
    title(['Signal audio - source ', num2str(r)]);
end

clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Lecture d'un fichier audio :
[y, f_ech] = audioread('Musiques/Au clair de la lune.wav');


% Passage dans le domaine fréquentiel :
n_fenetre = 1024;		% Largeur de la fenêtre (en nombre de points)
n_decalage = 512;		% Décalage entre deux fenêtres (en nombre de points)
fenetre = 'hann';		% Type de la fenêtre

[Y,valeurs_t,valeurs_f] = TFCT(y,f_ech,n_fenetre,n_decalage,fenetre);
S = 20*log10(abs(Y)+eps);

% NMF :
R = 5;
D_0 = rand(size(S,1),R);
A_0 = rand(R,size(S,2));
[D,A] = nmf(abs(Y),D_0,A_0,300);

% Sauvegarde de chaque composante :
for r = 1:R
	Y_r = (D(:,r)*A(r,:)) ./ (D*A) .* Y;
	[y_r,~] = ITFCT(Y_r,f_ech,n_decalage,fenetre);
	audiowrite(['Resultats/composante_' int2str(r) '.wav'],y_r,f_ech);
end

% Figures :
figure('Name','Dictionnaire et activations en sortie du NMF','Position',[0.4*L,0,0.6*L,0.6*H]);
subplot(1,2,1);
imagesc(1:R,valeurs_f,20*log10(abs(D)));
set(gca,'xtick',1:R)
caxis([-40 10]);
axis xy;
xlabel('Composantes','Interpreter','Latex','FontSize',30);
ylabel('Frequence ($Hz$)','Interpreter','Latex','FontSize',30);
title('$\mathbf{D}$','Interpreter','Latex','FontSize',30);

subplot(1,2,2);
imagesc(valeurs_t,1:R,A);
set(gca,'ytick',1:R)
axis xy;
xlabel('Temps ($s$)','Interpreter','Latex','FontSize',30);
ylabel('Composantes','Interpreter','Latex','FontSize',30);
title('$\mathbf{A}$','Interpreter','Latex','FontSize',30);

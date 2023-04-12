clear;
close all;

% Paramètres à régler :
nb_iterations = 1000;
epsilon = 0.5;
mu_prime = 5000;
gamma = 3e-5;
pas_affichage = 50;

% Mise en place de la figure pour affichage :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Decomposition structure + texture par le modele TV-Hilbert','Position',[0,0,L,0.5*H]);

% Lecture et affichage de l'image u :
u = imread('Images/pilier.png');
u = double(u);
[nb_lignes,nb_colonnes,nb_canaux] = size(u);
subplot(1,3,1);
imagesc(uint8(u));
axis equal;
axis off;
title('Image','FontSize',30);

% Fréquences en x et en y (axes = repère matriciel) :
[f_x,f_y] = meshgrid(1:nb_lignes,1:nb_colonnes);
f_x = f_x/nb_lignes-0.5;		% Fréquences dans l'intervalle [-0.5,0.5]
f_y = f_y/nb_colonnes-0.5;		% Idem
eta = 0.05;
Phi = eta./(f_x.^2+f_y.^2+eta);

% Calcul des matrices Dx et Dy :
nb_pixels = nb_lignes*nb_colonnes;
e = ones(nb_pixels,1);
Dx = spdiags([-e e],[0 nb_lignes],nb_pixels,nb_pixels);
Dx(nb_pixels-nb_lignes+1:nb_pixels,:) = 0;
Dy = spdiags([-e e],[0 1],nb_pixels,nb_pixels);
Dy(nb_lignes:nb_lignes:nb_pixels,:) = 0;

% Affichage de la structure initiale :
u_barre = u;
subplot(1,3,2);
imagesc(uint8(u_barre));
axis equal;
axis off;
title('Structure (0%)','FontSize',30);

% Affichage de la texture initiale :
subplot(1,3,3);
imagesc(uint8(u-u_barre));
axis equal;
axis off;
title('Texture (0%)','FontSize',30);

drawnow;

for it = 1:nb_iterations

	for c = 1:nb_canaux

		% Mise à jour de la structure :
		u_barre(:,:,c) = calcul_structure_3(u_barre(:,:,c),u(:,:,c),Dx,Dy,Phi,epsilon,mu_prime,gamma);
	end
	
	% Affichage tous les pas_affichage itérations :
	if mod(it,pas_affichage)==0
	
		% Affichage de la structure :
		subplot(1,3,2);
		imagesc(uint8(u_barre));
		axis equal;
		axis off;
		title(['Structure (' num2str(100*it/nb_iterations,'%.0f') '%)'],'FontSize',30);

		% Affichage de la texture :
		subplot(1,3,3);
		imagesc(uint8(u-u_barre));
		axis equal;
		axis off;
		title(['Texture (' num2str(100*it/nb_iterations,'%.0f') '%)'],'FontSize',30);

		drawnow;
	end
end

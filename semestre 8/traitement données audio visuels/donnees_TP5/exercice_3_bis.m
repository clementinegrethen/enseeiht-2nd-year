%--------------------------------------------------------------------------
% ENSEEIHT - 2SN MM - Traitement des donnees audio-visuelles
% TP5 - Restauration d'images
% exercice_3_bis : inpainting par rapieage (domaine D variable)
%--------------------------------------------------------------------------

clear
close all
clc

% Mise en place de la figure pour affichage :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Inpainting par rapiecage',...
	'Position',[0.06*L,0.1*H,0.9*L,0.75*H])

% Lecture de l'image :
u_0 = double(imread('Images/randonneur.jpg'));
[nb_lignes,nb_colonnes,nb_canaux] = size(u_0);
u_max = max(u_0(:));

% Affichage de l'image :
subplot(1,2,1)
	imagesc(max(0,min(1,u_0/u_max)),[0 1])
	axis image off
	title('Image originale','FontSize',20)
	if nb_canaux == 1
		colormap gray
	end

% Selection et affichage du domaine a restaurer :
disp('Selectionnez un polygone (double-clic pour valider)')
[D,x_D,y_D] = roipoly();
for k = 1:length(x_D)-1
	line([x_D(k) x_D(k+1)],[y_D(k) y_D(k+1)],'Color','b','LineWidth',2);
end

% Affichage de l'image resultat :
u_k = u_0;
for c = 1:nb_canaux
	u_k(:,:,c) = (~D).*u_k(:,:,c);
end
subplot(1,2,2)
	imagesc(max(0,min(1,u_k/u_max)),[0 1])
	axis image off
	title('Image resultat','FontSize',20)
	if nb_canaux == 1
		colormap gray
	end
drawnow nocallbacks

% Initialisation de la frontiere de D :
delta_D = frontiere(D);
indices_delta_D = find(delta_D > 0);
nb_points_delta_D = length(indices_delta_D);

% Parametres :
t = 9;			% Voisinage d'un pixel de taille (2t+1) x (2t+1)
T = 50;			% Fentre de recherche de taille (2T+1) x (2T+1)

% Tant que la frontiere de D n'est pas vide :
while nb_points_delta_D > 0

	% Pixel p de la frontiere de D tire aleatoirement :
	indice_p = indices_delta_D(randi(nb_points_delta_D));
	[i_p,j_p] = ind2sub(size(D),indice_p);

	% Recherche du pixel q_chapeau :
	[existe_q,bornes_V_p,bornes_V_q_chapeau] = d_min(i_p,j_p,u_k,D,t,T);

	% S'il existe au moins un pixel q eligible :
	if existe_q

		% Rapieage et mise a jour de D :
		[u_k,D] = rapiecage(bornes_V_p,bornes_V_q_chapeau,u_k,D);

		% Mise a jour de la frontiere de D :
		delta_D = frontiere(D);
		indices_delta_D = find(delta_D > 0);
		nb_points_delta_D = length(indices_delta_D);

		% Affichage de l'image resultat :
		subplot(1,2,2)
		imagesc(max(0,min(1,u_k/u_max)),[0 1])
		axis image off
		title('Image resultat','FontSize',20)
		if nb_canaux == 1
			colormap gray
		end
		drawnow nocallbacks
	end
end

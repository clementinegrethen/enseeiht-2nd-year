donnees;

% Parametres de la methode de segmentation :
T_0 = 1.0;
alpha = 0.99;
q_max = 50;
beta = 2.0;
N = 4;

% Estimation des parametres des N classes :
fprintf('Selectionnez %d echantillons\n',N);
moyennes = zeros(1,N);
variances = zeros(1,N);
for k = 1:N
	[x1,y1] = ginput(1);
	while (x1<1)||(x1>nb_colonnes)||(y1<1)||(y1>nb_lignes)
		[x1,y1] = ginput(1);
	end
	[x2,y2] = ginput(1);
	while (x2<1)||(x2>nb_colonnes)||(y2<1)||(y2>nb_lignes)||(x2==x1)||(y2==y1)
		[x2,y2] = ginput(1);
	end
	line([x1,x1],[y1,y2],'Color',couleurs_classes(k,:),'Linewidth',2);
	line([x1,x2],[y2,y2],'Color',couleurs_classes(k,:),'Linewidth',2);
	line([x2,x2],[y2,y1],'Color',couleurs_classes(k,:),'Linewidth',2);
	line([x2,x1],[y1,y1],'Color',couleurs_classes(k,:),'Linewidth',2);
	drawnow;

	echantillons = [];
	for i = floor(min([y1,y2])):ceil(max([y1,y2]))
		for j = floor(min([x1,x2])):ceil(max([x1,x2]))
			echantillons = [ echantillons I(i,j) ];
		end;
	end

	[moyennes(k),variances(k)] = estimation(echantillons);
end

% Permutation des classes pour pouvoir calculer le pourcentage de bonnes classifications :
[~,indices] = sort(moyennes,'ascend');
moyennes = moyennes(indices);
variances = variances(indices);
couleurs_classes = couleurs_classes(indices,:);

% Calcul de l'attache aux donnees (vraisemblance) :
AD = attache_donnees(I,moyennes,variances);

% Initialisation des classes :
couleurs_pixels = zeros(nb_lignes,nb_colonnes,3);
[U,k] = min(AD,[],3);
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		couleurs_pixels(i,j,:) = couleurs_classes(k(i,j),:);
	end
end
subplot(1,2,2);
imagesc(couleurs_pixels);
axis equal;
axis off;
title(['Maximum de vraisemblance'],'FontSize',20);
fprintf('Tapez un caractere pour lancer le recuit simule\n');
pause;

% Calcul de l'energie initiale :
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		k_voisins = k(max(i-1,1):min(i+1,nb_lignes),max(j-1,1):min(j+1,nb_colonnes));
		U(i,j) = U(i,j)+beta*regularisation(k_voisins,k(i,j),k(i,j));
	end
end

% Minimisation de l'energie par recuit simule :
temps_affichage = 0.05;
T = T_0;
for q = 1:q_max

	[U,k] = recuit(U,k,AD,T,beta);

	% Mise a jour de l'affichage :
	for i = 1:nb_lignes
		for j = 1:nb_colonnes
			couleurs_pixels(i,j,:) = couleurs_classes(k(i,j),:);
		end
	end
	imagesc(couleurs_pixels);
	axis equal;
	axis off;
	title(['Recuit simule : iteration ' num2str(q) '/' num2str(q_max)],'FontSize',20);
	pause(temps_affichage);

	% Mise a jour de la temperature :
	T = alpha*T;
end

% Calcul du pourcentage de pixels correctement classes :
pixels_correctement_classes = find(k==k_VT);
nb_pixels = nb_lignes*nb_colonnes;
fprintf('Pixels correctement classes : %.2f %%\n',100*length(pixels_correctement_classes(:))/nb_pixels);

donnees;

% Parametres de la methode de segmentation :
T_0 = 1.0;
alpha = 0.99;
q_max = 50;
beta = 2.0;
N = 4;

% Calcul de l'histogramme (normalise) de l'image :
I_max = 255;
liste_nvg = 0:I_max;
F = ksdensity(I(:),liste_nvg);				% Histogramme normalise de l'image

% Estimation du melange de gaussiennes par maximum de vraisemblance :
argument_min = Inf;
moyennes = zeros(1,N);
variances = zeros(1,N);
for t = 1:50000

	mu_test = I_max*rand(1,N);			% Loi uniforme entre 0 et 255
	sigma_test = 10+15*rand(1,N);			% Loi uniforme entre 10 et 25
	[poids,argument] = argument_eq_8(mu_test,sigma_test,liste_nvg,F);

	if argument<argument_min
		argument_min = argument;
		moyennes = mu_test;
		variances = sigma_test.^2;

		% Trace de l'histogramme :
		plot(liste_nvg,F,'LineWidth',3);
		xlabel('Niveau de gris $x$','FontSize',30,'Interpreter','Latex');
		ylabel('Densite de probabilite $f(x)$','FontSize',30,'Interpreter','Latex');
		set(gca,'FontSize',20);
		axis([0 I_max 0 1.2*max(F)]);
		hold on;

		% Trace du melange de gaussiennes estimees par maximum de vraisemblance :
		p_somme = zeros(size(liste_nvg));
		for k = 1:N
			mu_k = mu_test(k);
			sigma_k = sigma_test(k);
			gaussienne_k = poids(k)/sqrt(2*pi)*exp(-(liste_nvg-mu_k).^2/(2*sigma_k^2))/sigma_k;
			p_somme = p_somme+gaussienne_k;
		end
		plot(liste_nvg,p_somme,'k-','LineWidth',3);

		% Trace des N gaussiennes du melange :
		for k = 1:N
			mu_k = mu_test(k);
			sigma_k = sigma_test(k);
			gaussienne_k = poids(k)/sqrt(2*pi)*exp(-(liste_nvg-mu_k).^2/(2*sigma_k^2))/sigma_k;
			plot(liste_nvg,gaussienne_k,'--','Color',couleurs_classes(k,:),'LineWidth',3);
		end

		legend(' Histogramme',[' Melange de ' num2str(N) ' gaussiennes'],'');
		pause(0.1);
	end
	hold off;
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

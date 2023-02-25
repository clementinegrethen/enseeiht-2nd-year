donnees_2;
drawnow;

% Trace des donnees d'apprentissage (croix bleues) :
figure('Name','Estimation par le maximum de vraisemblance','Position',[0.33*L,0,0.33*L,0.5*H]);
h = zeros(1,3);
h(1) = plot(D_app(1,:),D_app(2,:),'+b','MarkerSize',10,'LineWidth',2);
set(gca,'FontSize',20);
xlabel('$x$','Interpreter','Latex','FontSize',30);
ylabel('$y$','Interpreter','Latex','FontSize',30);
axis([-taille taille -taille taille]);
axis equal;
hold on;

% Tirages aleatoires de parametres pour la paire d'ellipses :
nb_tirages = 20000;
parametres_test = zeros(nb_tirages,2,5);
parametres_test(:,:,1) = 2*taille/5*(rand(nb_tirages,2)+1);		% Demi-grand axe
parametres_test(:,:,2) = rand(nb_tirages,2);				% Excentricite
parametres_test(:,:,3) = (3*taille/5)*(2*rand(nb_tirages,2)-1);		% Abscisse du centre
parametres_test(:,:,4) = (3*taille/5)*(2*rand(nb_tirages,2)-1);		% Ordonnee du centre
parametres_test(:,:,5) = 2*pi*rand(nb_tirages,2);			% Angle du grand axe

% Estimation d'une paire d'ellipses par le maximum de vraisemblance :
parametres_estim = max_vraisemblance_2(D_app,parametres_test,sigma);
parametres_estim = reshape(parametres_estim,2,5);
parametres_1_estim = parametres_estim(1,:);
parametres_2_estim = parametres_estim(2,:);

% Trace des ellipses estimees par le maximum de vraisemblance (trait rouge) :
[x_1,y_1] = points_ellipse(parametres_1_estim,theta_affichage);
h(2) = plot([x_1 x_1(1)],[y_1 y_1(1)],'r-','LineWidth',3);
[x_2,y_2] = points_ellipse(parametres_2_estim,theta_affichage);
h(3) = plot([x_2 x_2(1)],[y_2 y_2(1)],'r-','LineWidth',3);
legend(h(1:2),' Donnees d''apprentissage',' Ellipses estimees','Location','Best');
drawnow;

% Calcul et affichage du score :
score = calcul_score_2(parametres_1_VT,parametres_2_VT,parametres_1_estim,parametres_2_estim);
fprintf('Score de l''estimation par MV : %.3f\n',score);

% Calcul des probabilites d'appartenance aux deux classes :
probas = probabilites(D_app,parametres_estim,sigma);
probas_classe_1 = probas(1,:);
probas_classe_2 = probas(2,:);

% Partition des donnees :
classe_1 = find(probas_classe_1>=probas_classe_2);
classe_2 = find(probas_classe_1<probas_classe_2);
D_app_1 = D_app(:,classe_1);
D_app_2 = D_app(:,classe_2);

% Affichage de la partition (croix bleues et vertes) :
figure('Name','Estimation par les moindres carres','Position',[0.66*L,0,0.33*L,0.5*H]);
plot(D_app_1(1,:),D_app_1(2,:),'+b','MarkerSize',10,'LineWidth',2);
set(gca,'FontSize',20);
xlabel('$x$','Interpreter','Latex','FontSize',30);
ylabel('$y$','Interpreter','Latex','FontSize',30);
axis([-taille taille -taille taille]);
axis equal;
hold on;
plot(D_app_2(1,:),D_app_2(2,:),'+g','MarkerSize',10,'LineWidth',2);

% Estimation en moindres carres :
X_1 = moindres_carres(D_app_1);
parametres_1_estim = conversion(X_1);
X_2 = moindres_carres(D_app_2);
parametres_2_estim = conversion(X_2);

% Trace des ellipses estimees en moindres carres (traits bleu et vert) :
[x_1,y_1] = points_ellipse(parametres_1_estim,theta_affichage);
plot([x_1 x_1(1)],[y_1 y_1(1)],'b-','LineWidth',3);
[x_2,y_2] = points_ellipse(parametres_2_estim,theta_affichage);
plot([x_2 x_2(1)],[y_2 y_2(1)],'g-','LineWidth',3);
legend(' Classe 1',' Classe 2',' Ellipse estimee 1',' Ellipse estimee 2','Location','Best');

% Calcul et affichage du score :
score = calcul_score_2(parametres_1_VT,parametres_2_VT,parametres_1_estim,parametres_2_estim);
fprintf('Score de l''estimation par MC : %.3f\n',score);

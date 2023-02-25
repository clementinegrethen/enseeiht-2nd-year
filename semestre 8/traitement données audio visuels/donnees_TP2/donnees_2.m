clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Parametres :
taille = 20;
echelle = [-taille taille -taille taille];

% Tirage aleatoire des parametres de la premiere ellipse :
a_1 = 2*taille/5*(rand+1);				% Demi grand axe
e_1 = 0.9*rand;						% Excentricite
x_C_1 = (taille-a_1)*(2*rand-1);			% Abscisse du centre
y_C_1 = (taille-a_1)*(2*rand-1);			% Ordonnee du centre
theta_1 = 2*pi*rand;					% Angle du grand axe
b_1 = a_1*sqrt(1-e_1^2);
R_1 = [cos(theta_1) -sin(theta_1) ; sin(theta_1) cos(theta_1)];
parametres_1_VT = [a_1,e_1,x_C_1,y_C_1,theta_1];

% Trace de la première ellipse (trait noir) :
figure('Name','Donnees d''apprentissage','Position',[0,0,0.33*L,0.5*H]);
n_affichage = 100;
theta_affichage = 2*pi/n_affichage:2*pi/n_affichage:2*pi;
P_1 = R_1*[a_1*cos(theta_affichage);b_1*sin(theta_affichage)]+[x_C_1;y_C_1]*ones(1,n_affichage);
x_1 = P_1(1,:);
y_1 = P_1(2,:);
h = zeros(1,3);
h(1) = plot([x_1 x_1(1)],[y_1 y_1(1)],'k-','LineWidth',3);
set(gca,'FontSize',20);
xlabel('$x$','Interpreter','Latex','FontSize',30);
ylabel('$y$','Interpreter','Latex','FontSize',30);
axis([-taille taille -taille taille]);
axis equal;
hold on;

% Tirage aleatoire des parametres de la deuxieme ellipse :
a_2 = 2*taille/5*(rand+1);				% Demi grand axe
e_2 = 0.9*rand;						% Excentricite
x_C_2 = (taille-a_2)*(2*rand-1);			% Abscisse du centre
y_C_2 = (taille-a_2)*(2*rand-1);			% Ordonnee du centre
theta_2 = 2*pi*rand;					% Angle du grand axe
b_2 = a_2*sqrt(1-e_2^2);
R_2 = [cos(theta_2) -sin(theta_2) ; sin(theta_2) cos(theta_2)];
parametres_2_VT = [a_2,e_2,x_C_2,y_C_2,theta_2];

% Trace de la deuxieme ellipse (trait noir) :
P_2 = R_2*[a_2*cos(theta_affichage);b_2*sin(theta_affichage)]+[x_C_2;y_C_2]*ones(1,n_affichage);
x_2 = P_2(1,:);
y_2 = P_2(2,:);
h(2) = plot([x_2 x_2(1)],[y_2 y_2(1)],'k-','LineWidth',3);

% Calcul des donnees d'apprentissage (bruit blanc sur x et sur y) :
n_app = 100;
sigma = 1;
theta_app = 2*pi*rand(1,n_app);
D_app_1 = R_1*[a_1*cos(theta_app);b_1*sin(theta_app)]+[x_C_1;y_C_1]*ones(1,n_app)+sigma*randn(2,n_app);
D_app_2 = R_2*[a_2*cos(theta_app);b_2*sin(theta_app)]+[x_C_2;y_C_2]*ones(1,n_app)+sigma*randn(2,n_app);
D_app = [D_app_1 D_app_2];

% Trace des donnees d'apprentissage (croix bleues) :
h(3) = plot(D_app(1,:),D_app(2,:),'+b','MarkerSize',10,'LineWidth',2);
legend(h(2:3),' Ellipses initiales',' Donnees d''apprentissage','Location','Best');

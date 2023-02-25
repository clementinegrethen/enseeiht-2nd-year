clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Parametres :
taille = 20;
echelle = [-taille taille -taille taille];

% Tirage aleatoire des parametres de l'ellipse :
a = 2*taille/5*(rand+1);				% Demi grand axe
e = 0.9*rand;						% Excentricite
x_C = (taille-a)*(2*rand-1);				% Abscisse du centre
y_C = (taille-a)*(2*rand-1);				% Ordonnee du centre
theta = 2*pi*rand;					% Angle du grand axe
b = a*sqrt(1-e^2);
R = [cos(theta) -sin(theta) ; sin(theta) cos(theta)];
parametres_VT = [a,e,x_C,y_C,theta];

% Trace de l'ellipse (trait noir) :
figure('Name','Donnees d''apprentissage','Position',[0,0,0.33*L,0.5*H]);
n_affichage = 100;
theta_affichage = 2*pi/n_affichage:2*pi/n_affichage:2*pi;
P = R*[a*cos(theta_affichage);b*sin(theta_affichage)]+[x_C;y_C]*ones(1,n_affichage);
x = P(1,:);
y = P(2,:);
plot([x x(1)],[y y(1)],'k-','LineWidth',3);
set(gca,'FontSize',20);
xlabel('$x$','Interpreter','Latex','FontSize',30);
ylabel('$y$','Interpreter','Latex','FontSize',30);
axis([-taille taille -taille taille]);
axis equal;
hold on;

% Calcul des donnees d'apprentissage (bruit blanc sur x et sur y) :
n_app = 100;
sigma = 1;
theta_app = 2*pi*rand(1,n_app);
D_app = R*[a*cos(theta_app);b*sin(theta_app)]+[x_C;y_C]*ones(1,n_app)+sigma*randn(2,n_app);

% Trace des donnees d'apprentissage (croix bleues) :
plot(D_app(1,:),D_app(2,:),'+b','MarkerSize',10,'LineWidth',2);
legend(' Ellipse initiale',' Donnees d''apprentissage','Location','Best');

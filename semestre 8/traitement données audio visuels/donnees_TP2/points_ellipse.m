function [x,y] = points_ellipse(parametres,theta_affichage)

a = parametres(1);		% Demi grand axe
e = parametres(2);		% Excentricite
x_C = parametres(3);		% Abscisse du centre
y_C = parametres(4);		% Ordonnee du centre
theta = parametres(5);		% Angle du grand axe
b = a*sqrt(1-e^2);
R = [cos(theta) -sin(theta) ; sin(theta) cos(theta)];

P = R*[a*cos(theta_affichage);b*sin(theta_affichage)]+[x_C;y_C]*ones(1,length(theta_affichage));
x = P(1,:);
y = P(2,:);

function r = calcul_r(D_app,parametres)

a = parametres(1);
e = parametres(2);
x_C = parametres(3);
y_C = parametres(4);
theta = parametres(5);
e_carre = e^2;
b_carre = a^2*(1-e_carre);
R = [cos(theta) -sin(theta) ; sin(theta) cos(theta)];

D_app = transpose(R)*(D_app-[x_C;y_C]*ones(1,size(D_app,2)));
x = D_app(1,:);
y = D_app(2,:);
rho = sqrt(x.^2+y.^2);
cos_angle = cos(atan(y./x));
rho_ellipse = sqrt(b_carre./(1-e_carre*cos_angle.^2));
r = rho-rho_ellipse;

function parametres = conversion(X)

alpha = X(1);
beta = X(2);
gamma = X(3);
delta = X(4);
epsilon = X(5);
phi = X(6);

% Calcul de l'angle theta :
theta = 1/2*atan(beta/(alpha-gamma));
c = cos(theta);
s = sin(theta);

% Calcul de la position du centre :
M = [2*alpha*c+beta*s 2*gamma*s+beta*c ; -2*alpha*s+beta*c 2*gamma*c-beta*s];
C = -inv(M)*[delta*c+epsilon*s ; -delta*s+epsilon*c];
x_C = C(1);
y_C = C(2);

% Calcul des demi-axes :
degre_0 = alpha*x_C^2+beta*x_C*y_C+gamma*y_C^2+delta*x_C+epsilon*y_C+phi;
a = sqrt(-degre_0/(alpha*c^2+beta*s*c+gamma*s^2));
b = sqrt(-degre_0/(alpha*s^2-beta*s*c+gamma*c^2));

% On force a>=b :
if b>a
	theta = theta+pi/2;
	aux = a;
	a = b;
	b = aux;
end
e = sqrt(1-b^2/a^2);

parametres = [a,e,x_C,y_C,theta];

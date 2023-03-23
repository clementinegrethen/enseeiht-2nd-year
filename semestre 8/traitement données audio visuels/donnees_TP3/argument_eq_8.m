function [poids,argument] = argument_eq_8(mu_test,sigma_test,liste_nvg,F)
% calcul des poids: on initialise la matrice A avec la formule (7)
N=length(mu_test);
poids= zeros(4,1);
A=zeros(255,N);
%pardon pour la double boucle for je n'ai pas voulu tester avec une simple
% car mon programme prend beaucoup trop de temps à tourner sur mon pc
for i=1:255
    for j=1:N
        num = -(i-mu_test(j))^2;
        den=2*(sigma_test(j))^2;
        A(i,j)=(1/(sigma_test(j)*sqrt(2*pi)))*exp(num/den);
    end
end;
A_tronque_1=A(:,1:1);
colonne_1=find(A_tronque_1>=0.0001);
A_tronque_2=A(:,2:2);
colonne_2=find(A_tronque_2>=0.0001);
A_tronque_3=A(:,3:3);
colonne_3=find(A_tronque_3>=0.0001);
A_tronque_4=A(:,4:4);
colonne_4=find(A_tronque_4>=0.0001);
A_tronque_systeme=[A(colonne_1(1),:);A(colonne_2(1),:);A(colonne_3(1),:);A(colonne_4(1),:)];
F_tronque=zeros(4,1);
F_tronque(1)=F(colonne_1(1));
F_tronque(2)=F(colonne_2(2));
F_tronque(3)=F(colonne_3(3));
F_tronque(4)=F(colonne_4(4));
size(A_tronque_systeme);
poids=A_tronque_systeme\F_tronque;
size(poids);
% on a le poids en ayant réalisé un systeme linéaire en isolant
% des valeurs de la matrice A qui permettent de calculer p1,p2,p3,p4
% calculons les arguments qui minimise (8)
res=zeros(255,1)
for i=1:255
     for j=1:N
        res(i)=res(i)+poids(j)*A(i,j);
    end
end
res_tronque=res(colonne_1(1):colonne_4(4));
argument=find(res_tronque==min(res_tronque));
argument=argument+colonne_1(1)-1;
    

end




clear;
close all;

% Vérités terrain
verif_Y = [3.75 8.25 12.75 17.25;-2.25-1.5i -4.5-3.75i -6.75-6i -9-8.25i;0.75 0.75 0.75 0.75];
verif_t = [0 0.3 0.6 0.9];
verif_f = [0 2.5 5];

f_ech = 10;
y = (1:12);
n_fenetre = 4;
n_decalage = 3;
fenetre = 'hann';

[Y,valeurs_t,valeurs_f] = TFCT(y, f_ech, n_fenetre, n_decalage, fenetre);

if size(Y,1)~=(n_fenetre/2+1)
	disp('Le nombre de lignes n''est pas bon : avez-vous supprimé les fréquences négatives ?');
end

if size(Y,2)~=ceil((length(y)-n_fenetre)/n_decalage)+1
	disp('Le nombre de colonnes n''est pas bon : vérifiez l''appel a la fonction buffer !');
end

% if ~isequal(Y,verif_Y)
if ~all(abs(Y - verif_Y) <= 1e-10)
	disp('La matrice TFCT n''est pas correcte : le fenêtrage a-t-il ete effectué correctement ?')
end

if ~isequal(valeurs_f,verif_f)
	disp('Les valeurs de f ne sont pas correctes : vont-elles bien de 0 Hz a (f_ech/2) Hz ?')
end

if ~all(abs(valeurs_t- verif_t) <= 1e-10)
	disp('Les valeurs de t ne sont pas correctes : quels échantillons sont analysés dans la k-ieme colonne de la TFCT ?')
end

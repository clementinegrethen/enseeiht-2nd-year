clear;
close all;

% Chargement des paramètres (voir parametres.m)
load parametres;

bdd_2 = containers.Map('KeyType','uint32','ValueType','any');

for id = 1:length(fichiers)

    % Lecture d'un fichier audio :
    disp(fichiers(id).name);
    [y, f_ech] = audioread(chemin_reechantillone + fichiers(id).name);
    y = mean(y, 2);

    % Calcul du sonagramme :
    [Y, valeurs_t, valeurs_f] = TFCT(y, f_ech, n_fenetre, n_decalage, fenetre);
    S = 20*log10(abs(Y)+eps);

    % Calcul des pics spectraux :
    [pics_t, pics_f] = pics_spectraux(S, eta_t, eta_f, epsilon);

    % Calcul des triplets de pics spectraux :
    triplets = appariement_Triplets(pics_t, pics_f, n_v, delta_t, delta_f);

    % Calcul des identifiants :
    identifiants = indexation_triplets(triplets);

    % Stockage des identifiants :
    for i = 1:length(identifiants)
        identifiant = identifiants(i);
        entree = [triplets(i,5) id];
        if bdd_2.isKey(identifiant)
            bdd_2(identifiant) = [bdd_2(identifiant) ; entree];
        else
            bdd_2(identifiant) = [entree];
        end
    end
end

save bdd_2.mat bdd_2;

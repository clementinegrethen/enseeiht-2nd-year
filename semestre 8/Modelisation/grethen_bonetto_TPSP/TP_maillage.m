clear all;
close all;
% Nombre d'images utilisees
nb_images = 36; 

% chargement des images
for i = 1:nb_images
    if i<=10
        nom = sprintf('images/viff.00%d.ppm',i-1);
    else
        nom = sprintf('images/viff.0%d.ppm',i-1);
    end
    % im est une matrice de dimension 4 qui contient 
    % l'ensemble des images couleur de taille : nb_lignes x nb_colonnes x nb_canaux 
    % im est donc de dimension nb_lignes x nb_colonnes x nb_canaux x nb_images
    im(:,:,:,i) = imread(nom); 
end

% Affichage des images
figure; 
subplot(2,2,1); imshow(im(:,:,:,1)); title('Image 1');
subplot(2,2,2); imshow(im(:,:,:,9)); title('Image 9');
subplot(2,2,3); imshow(im(:,:,:,17)); title('Image 17');
subplot(2,2,4); imshow(im(:,:,:,25)); title('Image 25');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                                             %
% Calculs des superpixels                                 % 
% Conseil : afficher les germes + les régions             %
% à chaque étape / à chaque itération                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ........................................................%
k = 200;
[m,n] = size(im(:,:,1,1));
s = sqrt(m*n/k);
% initilisa tion des centres répartis sur l'image de manière homogène avec meshgrid
% Créattion de la grille 
[XX,YY] = meshgrid(s/2:s:m,s/2:s:n);
[taille1,taille2]=size(XX);
Nombre_classe=taille1*taille2;
centre = zeros(Nombre_classe,5);
abs_centre=(XX');
abs_centre=abs_centre(:);
ord_centre=(YY');
ord_centre=ord_centre(:);
% on initialise les positions x et y des centres dans les colonnes 4 et 5
centre(:,4)=abs_centre;
centre(:,5)=ord_centre;

% on affine la grille 
% il faut chercher le pixel de gradient le plus faible dans un voisinage
% 3X3
im_1=im2double(im(:,:,:,1));
% calcul du gradient 
[Gmag, Gdir] = imgradient(rgb2gray(im(:,:,:,1)));
imshow(Gmag, []);
n_affinage=3;
centre_avant=centre;
for i = 1:Nombre_classe
    % gradient dans le voisinage 
     gradient_k = Gmag(max(centre(i,4)-n_affinage,1):min(centre(i,4)+n_affinage,m),max(centre(i,5)-n_affinage,1):min(centre(i,5)+n_affinage,n));
    % on choisit le minimum
    [min_val, min_ind] = min(gradient_k(:));
    [row, col] = ind2sub(size(gradient_k), min_ind);
    centre(i,1)=im_1(round(centre(i,4)+row-(n_affinage+1)),round(centre(i,5)+col-(n_affinage+1)),1);
    centre(i,2)=im_1(round(centre(i,4)+row-(n_affinage+1)),round(centre(i,5)+col-(n_affinage+1)),2);
    centre(i,3)=im_1(round(centre(i,4)+row-(n_affinage+1)),round(centre(i,5)+col-(n_affinage+1)),3);
    centre(i,4) =  round(centre(i,4)+row-(n_affinage+1));
    centre(i,5) = round(centre(i,5)+col-(n_affinage+1));

end
%% on affiche la grille sur l'image
figure;
imshow(im(:,:,:,1));
hold on;
plot(centre(:,5),centre(:,4),'r*');
hold on;
plot(centre_avant(:,5),centre_avant(:,4),'g*');
title('grille avec les centres des superpixels')
hold off;
%% Evolution des centres de chaque pixel: Algorithme SLIC
% On va créer une matrice à 5 colonnes X le nombre de pixel 
% Cela permet de calculer facilement la distance Ds
pixel_kmeans = zeros(n*m,5);
l=1;
%pixel_kmeans=im2double(pixel_kmeans);
% elle contient dans les 3 premières colonnes les pixels de l'image 
for i=1:m
    for j=1:n
        pixel_kmeans(l,:)=[im_1(i,j,1) im_1(i,j,2) im_1(i,j,3) i j];
        l=l+1;
    end
end
m_S=0.3;
pixel_kmeans_copie=pixel_kmeans;
% coefficient selon SLIC
centre(:,4)= centre(:,4)*(m_S/s);
centre(:,5)=centre(:,5)*(m_S/s);
pixel_kmeans(:,4)=pixel_kmeans(:,4)*(m_S/s);
pixel_kmeans(:,5)=pixel_kmeans(:,5)*(m_S/s);
% IDX est un vecteur colonne qui indique à quel cluster chaque pixel de l'image a été assigné
% C est une matrice qui contient les centres des K clusters
[idx, C] = kmeans(pixel_kmeans,Nombre_classe,'Start',centre,'MaxIter',100);
C(:,4)= C(:,4)*(s/m_S);
C(:,5)=C(:,5)*(s/m_S);
% Adapation 
[nb_lignes, nb_colonnes, ~]=size(im);
idx=(reshape(idx,size(im_1,2),size(im_1,1)))';
figure
mask=boundarymask(idx);
figure;
imshow(labeloverlay(im_1,mask,'Transparency',0))
title('SLIC superpixels')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                                             %
% Binarisation de l'image à partir des superpixels        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On récupère la couleur des centres
couleurs = C(:,1:3);
canal= C(:,1);
% methode de Otsu grâce à Graytresh
seuil=graythresh(canal);
% on concertit en niveau de gris 
% C_gray = 0.2989 * couleurs(:,1) + 0.5870 * couleurs(:,2) + 0.1140 * couleurs(:,3);
% level = 0.6
% Seuillage des centres de superpixels pour obtenir une segmentation binaire
binaryImg = ones(size(im_1,1), size(im_1,2));
% I = kmeans(couleurs,2);
for k = 1:Nombre_classe
    if canal(k)<seuil
        binaryImg(idx==k) = 0;
    end
end

% Affichage de la segmentation binaire
BW=imfill(binaryImg);
s = size(BW);
figure;
imshow(BW);
title('Segmentation Binaire de im1');
hold off;

%%%%%%%%%%%%%%%%%%% Estimation de l'axe médian%%%%%%%%%%%%%%%%%%

% trouver un pixel sur la frontière pour applique bwtraceboundary
% Trouver un pixel sur la frontière pour appliquer bwtraceboundary

flag = 0;
for i = 1:s(1)-1
    for j = 1:s(2)-1
        % Quand on se trouve à la frontière, la valeur change
        if BW(i,j) ~= BW(i,j+1)
            flag = 1;
            break
        end
    end
    if flag
        break
    end
end
% On récupère le pixel qui appartient au contour
pixel_contour = [i,j+1];
figure;
imshow(BW);

% On trace le contour
contour=bwtraceboundary(binaryImg,pixel_contour,'W',8,Inf,'counterclockwise');
hold on;
plot(contour(:,2),contour(:,1),'g','LineWidth',2);
title('Frontière en Vert sur im1')
hold off;

% Calcul de la matrice de Voronoï
[vx, vy] = voronoi(contour(:,2), contour(:,1));
% Recherche des points à l'extérieur de l'image 
points_ext_x=[find(vx(1,:)>=nb_lignes) find(vx(2,:)>=nb_colonnes) find(vx(1,:)<=0) find(vx(2,:)<=0)];
points_ext_y=[find(vy(1,:)>=nb_lignes) find(vy(2,:)>=nb_colonnes) find(vy(1,:)<=0) find(vy(2,:)<=0)];
% on supprime les points qui sont à l'extérieur de l'image 
vx(:,[points_ext_x points_ext_y])=[];
vy(:,[points_ext_x points_ext_y])=[];
% on retire maintenant les points en dehors de la forme 
points_a_retirer=[];
for i=1:length(vx)
    vx1=min(max(1,round(vx(1,i))),nb_colonnes);
    vx2=min(max(1,round(vx(2,i))),nb_colonnes);
    vy1=min(max(1,round(vy(1,i))),nb_lignes);
    vy2=min(max(1,round(vy(2,i))),nb_lignes);
    % condition: être dans la partie noire de l'image: on retire 
    if BW(vy1,vx1)==0 || BW(vy2,vx2)==0
        points_a_retirer=[points_a_retirer i];
    end
end

vx(:,points_a_retirer)=[];
vy(:,points_a_retirer)=[];
figure;
imshow(BW);
hold on;
plot(vx,vy);
title('squelette')
hold off;



% partie bonus: vérification avec des cercles
% Coordonnées du centre du cercle
% Rayon du cercle

x0 = vx;
y0 = vy;
[taille1,taille2]=size(vx);
figure;
for i=1:taille2
    x0= vx(1,i);
    y0= vy(1,i);
    x1= vx(2,i);
    y1= vy(2,i);
    rayon = pdist2([x0 y0], [x1 y1]);

    % Création des points du cercle
    theta = linspace(0, 2*pi);
    k1 = rayon * cos(theta) + x0;
    k2 = rayon * sin(theta) + y0;
    hold on;
    % Tracé du cercle
    plot(k1, k2, 'r');
    k3 = rayon * cos(theta) + x0;
    k4 = rayon * sin(theta) + y0;
     hold on;
    % Tracé du cercle
    plot(k3, k4, 'r');
end 
title('partie bonus: affichage des cercles')
hold off; 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A FAIRE SI VOUS UTILISEZ LES MASQUES BINAIRES FOURNIS   %
% Chargement des masques binaires                         %
% de taille nb_lignes x nb_colonnes x nb_images           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER ET COMPLETER                              %
% quand vous aurez les images segmentées                  %
% Affichage des masques associes                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% subplot(2,2,1); ... ; title('Masque image 1');
% subplot(2,2,2); ... ; title('Masque image 9');
% subplot(2,2,3); ... ; title('Masque image 17');
% subplot(2,2,4); ... ; title('Masque image 25');

% chargement des points 2D suivis 
% pts de taille nb_points x (2 x nb_images)
% sur chaque ligne de pts 
% tous les appariements possibles pour un point 3D donne
% on affiche les coordonnees (xi,yi) de Pi dans les colonnes 2i-1 et 2i
% tout le reste vaut -1
pts = load('viff.xy');
% Chargement des matrices de projection
% Chaque P{i} contient la matrice de projection associee a l'image i 
% RAPPEL : P{i} est de taille 3 x 4
load dino_Ps;

% Reconstruction des points 3D
X = []; % Contient les coordonnees des points en 3D
color = []; % Contient la couleur associee
% Pour chaque couple de points apparies
for i = 1:size(pts,1)
    % Recuperation des ensembles de points apparies
    l = find(pts(i,1:2:end)~=-1);
    % Verification qu'il existe bien des points apparies dans cette image
    if size(l,2) > 1 & max(l)-min(l) > 1 & max(l)-min(l) < 36
        A = [];
        R = 0;
        G = 0;
        B = 0;
        % Pour chaque point recupere, calcul des coordonnees en 3D
        for j = l
            A = [A;P{j}(1,:)-pts(i,(j-1)*2+1)*P{j}(3,:);
            P{j}(2,:)-pts(i,(j-1)*2+2)*P{j}(3,:)];
            R = R + double(im(int16(pts(i,(j-1)*2+1)),int16(pts(i,(j-1)*2+2)),1,j));
            G = G + double(im(int16(pts(i,(j-1)*2+1)),int16(pts(i,(j-1)*2+2)),2,j));
            B = B + double(im(int16(pts(i,(j-1)*2+1)),int16(pts(i,(j-1)*2+2)),3,j));
        end;
        [U,S,V] = svd(A);
        X = [X V(:,end)/V(end,end)];
        color = [color [R/size(l,2);G/size(l,2);B/size(l,2)]];
    end;
end;
fprintf('Calcul des points 3D termine : %d points trouves. \n',size(X,2));

%affichage du nuage de points 3D
figure;
hold on;
for i = 1:size(X,2)
    plot3(X(1,i),X(2,i),X(3,i),'.','col',color(:,i)/255);
end;
axis equal;
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                  %
% Tetraedrisation de Delaunay  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off; 
T = DelaunayTri(X(1,:)',X(2,:)', X(3,:)');

% A DECOMMENTER POUR AFFICHER LE MAILLAGE
fprintf('Tetraedrisation terminee : %d tetraedres trouves. \n',size(T,1));
% Affichage de la tetraedrisation de Delaunay
 figure;
 tetramesh(T);
title('Triangulation des points reconstruits');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER ET A COMPLETER %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%on v ́erifie que chaque tétraèdre inclus dans làobjet 3D se projette à l'intérieur de llimage d'un objet
% Calcul des barycentres de chacun des tetraedres
% On applique 5 pondérations différentes : une uniforme et les 4 autres favorisant un des 4 sommets 
poids = [1, 1, 1, 1; 20, 1, 1, 1; 1, 20, 1, 1; 1, 1, 20, 1; 1, 1, 1,20];
nb_barycentres = size(poids,2);
load mask;
for i = 1:size(T,1)
    % On récupère les indices des sommets
    Ti = T(i,:);
    % On récupère les coordonnées des sommets
    Pi = T.X(Ti,:);
    for k=1:nb_barycentres
        % On calcul des barycentres differents en fonction des poids differents
        C_g(:,i,k) = [sum(Pi.*poids(k,:)',1)/sum(poids(k,:)) 1]; 
    end
end 

% A DECOMMENTER POUR VERIFICATION 
% A RE-COMMENTER UNE FOIS LA VERIFICATION FAITE
% Visualisation pour vérifier le bon calcul des barycentres
% for i = 1:nb_images
%    for k = 1:nb_barycentres
%        o = P{i}*C_g(:,:,k);
%        o = o./repmat(o(3,:),3,1);
%        imshow(im_mask(:,:,i));
%        hold on;
%        plot(o(2,:),o(1,:),'rx');
%        %pause;
%        %close;
%    end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER ET A COMPLETER %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copie de la triangulation pour pouvoir supprimer des tetraedres
tri=T.Triangulation;
% Retrait des tetraedres dont au moins un des barycentres 
% ne se trouvent pas dans au moins un des masques des images de travail
% Pour chaque barycentre
removed_i = [];

 for k=1:nb_barycentres
     for i = 1:nb_images
        for i_tetra=1:size(tri,1)
             o = P{i}*C_g(:,i_tetra,k);
             o = o./repmat(o(3,:),3,1);
             x = round(o(1));
             y = round(o(2));
             % On vérifie que le barycentre est bien projeté l'image
             if(x>0 && y>0 && x<size(im_mask,1) && y<size(im_mask,2))
                % On vérifie ensuite s'il est projeté sur le masque 
                if (im_mask(x,y,i) == 1)
                    % On retire le barycentre qui ne se projette pas dans la région du dinosaure dans au moins une des 36 images
                    removed_i = [removed_i; i_tetra];
                end
             else
                 % Le barycentre n'est pas projeté dans l'image
                 removed_i = [removed_i; i_tetra];
             end

        end
     end
 end
triInd = unique(removed_i);
tri(triInd,:)=[];
 
% A DECOMMENTER POUR AFFICHER LE MAILLAGE RESULTAT
% Affichage des tetraedres restants
fprintf('Retrait des tetraedres exterieurs a la forme 3D termine : %d tetraedres restants. \n',size(tri,1));
figure;
trisurf(tri,X(1,:),X(2,:),X(3,:));

% Sauvegarde des donnees
save donnees;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSEIL : A METTRE DANS UN AUTRE SCRIPT %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load donnees;
% Calcul des faces du maillage à garder
% FACES = ...;
% ...

% fprintf('Calcul du maillage final termine : %d faces. \n',size(FACES,1));

% Affichage du maillage final
% figure;
% hold on
% for i = 1:size(FACES,1)
%    plot3([X(1,FACES(i,1)) X(1,FACES(i,2))],[X(2,FACES(i,1)) X(2,FACES(i,2))],[X(3,FACES(i,1)) X(3,FACES(i,2))],'r');
%    plot3([X(1,FACES(i,1)) X(1,FACES(i,3))],[X(2,FACES(i,1)) X(2,FACES(i,3))],[X(3,FACES(i,1)) X(3,FACES(i,3))],'r');
%    plot3([X(1,FACES(i,3)) X(1,FACES(i,2))],[X(2,FACES(i,3)) X(2,FACES(i,2))],[X(3,FACES(i,3)) X(3,FACES(i,2))],'r');
% end;
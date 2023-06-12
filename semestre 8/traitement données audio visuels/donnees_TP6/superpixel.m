
im=imread('BinomialCoefficientExample_01.ppm');



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
im_1=im2double(im);
% calcul du gradient 
[Gmag, Gdir] = imgradient(rgb2gray(im));
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
imshow(im);
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

% end;
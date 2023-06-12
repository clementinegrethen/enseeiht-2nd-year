% Load and convert the image
image = imread('Images/pilier.png');
image_gray = rgb2gray(image);
image_gray = im2double(image_gray);

% On applique la SVC
[U, S, V] = svd(image_gray);

% SDéfinition d'un seuil pour les valeurs singulières
threshold = 0.05;  

% on regarde les valeurs singulière qu'on va garder
singular_values = diag(S);
keep_values = singular_values >= threshold * singular_values(1);

image_structure = U(:,keep_values) * S(keep_values,keep_values) * V(:,keep_values)';

image_texture = image_gray - image_structure;

figure;
subplot(1, 3, 1), imshow(image_gray), title('Original Image');
subplot(1, 3, 2), imshow(image_structure), title('Structure');
subplot(1, 3, 3), imshow(image_texture + 0.5), title('Texture');

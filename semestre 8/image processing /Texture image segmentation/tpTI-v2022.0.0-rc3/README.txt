Pour exécuter Kmeans:

1) Exécuter sans la segmentation de référence:

./bin/kmeans ../data/images/texture8.png 2 
--> Cela affichera les résultats de Kmeans sans segmentation de référence pour 2 classes de l'image texture8.png

2) Exécuter avec la segmentation de référence:
./bin/kmeans ../data/images/texture8.png ../data/images/texture8_VT.png 2
--> Cela affichera les résultats de Kmeans avec segmentation de référence pour 2 classes de l'image texture8.png 
ainsi que les calculs de qualité du résultat.

Pour exécuter meanshift :

./bin/meanshift ../data/images/texture8.png 
--> Cela affichera les résultats de meanshift sans segmentation de référence de l'image texture8.png

2) Exécuter avec la segmentation de référence:
./bin/meanshift ../data/images/texture8.png ../data/images/texture8_VT.png 
--> Cela affichera les résultats de meanshift avec segmentation de référence de l'image texture8.png 
ainsi que les calculs de qualité du résultat.


Précision : 
* Pour utiliser le kmeans (meanshift) de openCv décommenter la ligne 147 (140) du fichier kmeans.cpp (meanshift.cpp) et commenter la ligne 148 (141) du fichier kmeans.cpp (meanshift.cpp). 
* Dans le cas où la texture possède un fond de couleur plus sombre que la forme (comme dans l'image texture3.png), il faut inverser le noir et le blanc:
- Dans kmeans il faut inverser les valeurs 255 et 0 sur les lignes 153 154
- Dans meanshift il faut jouer sur le dernier argument de l'appel à threshold : remplacer THRESH_BINARY par THRESH_BINARY_INV


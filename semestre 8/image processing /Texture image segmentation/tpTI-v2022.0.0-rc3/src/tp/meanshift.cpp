
#include "ocv_utils.hpp"

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <iostream>
#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;


void printHelp(const string& progName)
{
    cout << "Usage:\n\t " << progName << " <image_file> [<image_ground_truth>]" << endl;
}

// Algorithme de notre implémentation de mean-shift
// fonction meanshift : réalise l'algorithme meanshift sur une image
// Données en entrée  : data : image à segmenter
//                      result : image segmentée
//                      termcrit : critère d'arrêt
//                      spatialRad : rayon spatial
//                      colorRad : rayon de couleur

void meanshift(Mat& data, Mat& result, TermCriteria termcrit, int spatialRad, int colorRad)
{   
    
    // on redimensionne data pour qu'il soit un vecteur de pixels 
    data.reshape(1, data.rows * data.cols);
    // result prend la valeur de data
    result = data.clone();
    // on parcourt tous les pixels de data
    for (int i = 0; i < data.total(); i++) { 
        // on récupère le pixel i, 
        Vec3b pixel = result.at<Vec3b>(i);
        // on initialise le mode à pixel
        Vec3b mode = pixel;
        bool converged = false;
        while (!converged) {
            // on calcule la moyenne des pixels voisins de pixel c'est à dire les pixels qui sont dans le rayon spatial et qui ont une couleur proche de pixel
            Vec3i sum (0, 0, 0);
            int count = 0;
            for (int x = -spatialRad; x <= spatialRad; x++) {
                for (int y = -spatialRad; y <= spatialRad; y++) {
                    // on récupère l'index du pixel voisin (data est un vecteur de pixels)
                    int index = i + x + y * data.cols;
                    // on vérifie que l'index est valide : si il ne l'est pas, on passe au pixel suivant
                    if (index < 0 || index >= data.total()) {
                        continue;
                    }
                    // on récupère le pixel voisin
                    Vec3b voisin = result.at<Vec3b>(index);
                    // on vérifie que le pixel voisin est dans le rayon de couleur (appartenance à Sh(x))
                    if (norm(Vec3i(pixel) - Vec3i(voisin)) < colorRad) {
                        // on ajoute le pixel voisin à la somme
                        sum += Vec3i(voisin);
                        count++;
                    }
                }
            }
            // on calcule le mode
            mode = Vec3b(sum / count);
            Vec3b shift = mode - pixel;
            // on vérifie si le critère d'arrêt est atteint
            if (norm(shift) < termcrit.epsilon) {
                converged = true;
            // sinon on déplace le pixel vers le mode
            } else {
                pixel += shift;
            }
        }
        // on affecte le mode au pixel i de result
        result.at<Vec3b>(i) = mode;
        // on passe au pixel suivant
    }
    //result.reshape(3, data.rows);
    return;
}

int main(int argc, char** argv)
{
 
    if (argc != 2 && argc != 3)
    {
        cout << " Incorrect number of arguments." << endl;
        printHelp(string(argv[0]));
        return EXIT_FAILURE;
    }

    const auto imageFilename = string(argv[1]);
    const string groundTruthFilename = (argc == 3) ? string(argv[2]) : string();


    // just for debugging
    {
        cout << " Program called with the following arguments:" << endl;
        cout << " \timage file: " << imageFilename << endl;
        if(!groundTruthFilename.empty()) cout << " \tground truth segmentation: " << groundTruthFilename << endl;
    }

    Mat m, m_ref;
    // on charge l'image
    m = imread(imageFilename, IMREAD_COLOR);
    // on vérifie que l'image est valide
    if(m.empty())
    {
        cout << "Could not open or find the image" << std::endl;
        return EXIT_FAILURE;
    }
    // on charge l'image de référence
    if (argc == 3) {
        m_ref = imread(groundTruthFilename, IMREAD_GRAYSCALE);
        if(m_ref.empty())
        {
            cout << "Could not open or find the image" << std::endl;
            return EXIT_FAILURE;
        }
    }
    // convertir en espace couleur L*a*b
    cvtColor(m, m, COLOR_BGR2Lab);

    //on définit les paramètres pour meanshift
        // termcrit : critère d'arrêt
    TermCriteria termcrit(TermCriteria::MAX_ITER | TermCriteria::EPS, 5, 1);
        // spatialRad : rayon spatial
    int spatialRad = 20;
        // colorRad : rayon de couleur
    int colorRad = 10;
        // maxPyrLevel : nombre de niveaux de l'image
    int maxPyrLevel = 1;
        // result : image segmentée
    Mat result;
    //on applique meanshift avec la fonction pyrMeanShiftFiltering
    //pyrMeanShiftFiltering(m, result, spatialRad, colorRad, maxPyrLevel, termcrit);
    meanshift(m, result, termcrit, spatialRad, colorRad);
    // on convertit l'image segmentée en espace couleur BGR
    cvtColor(result, result, COLOR_Lab2BGR);
    // on affiche l'image segmentée
    namedWindow(imageFilename, cv::WINDOW_AUTOSIZE);
    imshow(imageFilename, imread(imageFilename));
    imshow("Segmented Image", result);

    // Evaluation de la qualité de la segmentation
    // on convertit l'image segmentée en espace couleur gris
    cvtColor(result, result, COLOR_BGR2GRAY);
    // on applique un seuillage binaire inverse à l'image segmentée pour obtenir une image binaire (0 ou 255)
    threshold(result, result, 255/2, 255, THRESH_BINARY_INV);

    imshow("Segmented Binary Image", result);

    long TP = 0, FP = 0, FN = 0;
    if (!m_ref.empty()) {

        for (int i = 0; i < m.rows; i++)
        {
            for (int j = 0; j < m.cols; j++)
            {
                // on vérifie si le pixel est dans la zone de vrai positif
                if (m_ref.at<uchar>(i,j) == 255 && result.at<uchar>(i,j) == 255)
                    TP++;
                // on vérifie si le pixel est dans la zone de faux positif
                else if (m_ref.at<uchar>(i,j) == 0 && result.at<uchar>(i,j) == 255)
                    FP++;
                // on vérifie si le pixel est dans la zone de faux négatif
                else if (m_ref.at<uchar>(i,j) == 255 && result.at<uchar>(i,j) == 0)
                    FN++;
            }
        }
        // on calcule les métriques
        double Precision   = (double) TP/(TP+FP);
        double Sensibilite = (double) TP/(TP+FN);
        double DICE_coef   = (double) (2*TP)/(2*TP+FP+FN);
         // on affiche les métriques
        cout << "TP: " << TP << endl;
        cout << "FP: " << FP << endl;
        cout << "FN: " << FN << endl;
        cout << "Précision: " << Precision << endl;
        cout << "Sensibilité: " << Sensibilite << endl;
        cout << "DICE Coefficient: " << DICE_coef << endl;

        namedWindow(groundTruthFilename, cv::WINDOW_AUTOSIZE);
        imshow(groundTruthFilename, m_ref);
    }
   
    cv::waitKey(0);

    return 0;
    }

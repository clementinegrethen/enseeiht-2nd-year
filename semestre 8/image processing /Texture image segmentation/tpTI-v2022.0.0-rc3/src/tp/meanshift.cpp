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
#include <iostream>
#include <vector>

using namespace std;

Mat submatrix(Mat& matrix, int li,int co, int n,int hc) {
    int start_row = max(0, li - n);          // Ligne de départ de la sous-matrice
    int end_row = min(matrix.rows - 1, li + n);    // Ligne de fin de la sous-matrice
    int start_col = max(0, co - n);          // Colonne de départ de la sous-matrice
    int end_col = min(matrix.cols - 1, co + n); // Colonne de fin de la sous-matrice

    // Si la sous-matrice de taille (2n+1)x(2n+1) existe dans la matrice, l'extraire et la renvoyer
    if (start_row <= end_row && start_col <= end_col) {

        Mat submatrix;

        // Parcourir les lignes de la matrice originale
        for (int i = start_row; i <= end_row; i++) {
            std::vector<cv::Vec3b> row;

            // Parcourir les colonnes de la matrice originale
            for (int j = start_col; j <= end_col; j++) {
                row.push_back(matrix.at<cv::Vec3b>(i, j));
            }

            submatrix.push_back(row);
        }

    // éliminer les points qui ont une couleur trop différente de x 
        for (int i = 0; i < submatrix.rows; i++) {
            for (int j = 0; j < submatrix.cols; j++) {
                if (abs(submatrix.at<cv::Vec3b>(i, j)[0] -matrix.at<cv::Vec3b>(li, co)[0]) > hc) {

                    submatrix.at<int>(i, j) = -1;
                }
            }
        }

            return submatrix;

    }
    // Sinon, renvoyer la plus grande sous-matrice possible centrée sur x
    else {
        int size = std::min(matrix.rows, matrix.cols);
        int max_n = (size - 1) / 2;
        start_row = li - max_n;
        end_row = li + max_n;
        start_col = co - max_n;
        end_col = co + max_n;

        Mat submatrix;

        // Parcourir les lignes de la matrice originale
        for (int i = start_row; i <= end_row; i++) {
            std::vector<cv::Vec3b> row;

            // Parcourir les colonnes de la matrice originale
            for (int j = start_col; j <= end_col; j++) {
                if (i >= 0 && i < matrix.rows && j >= 0 && j < matrix.cols) {
                    row.push_back(matrix.at<cv::Vec3b>(i, j));
                }
            }

            submatrix.push_back(row);
        }
        // éliminer les points qui ont une couleur trop différente de x 
        for (int i = 0; i < submatrix.rows; i++) {
            for (int j = 0; j < submatrix.cols; j++) {
                if (abs(submatrix.at<cv::Vec3b>(i, j)[0] -matrix.at<cv::Vec3b>(li, co)[0]) > hc) {
                    submatrix.at<int>(i, j) = -1;
                }
            }
        }
            return submatrix;
        
    }

    

}



void meanshift( Mat& m, int hs, int hc, int eps, int max) {
    // segmentation alogirthme mean-shift 
    int k = 1;
    bool convergence = false;
    // mean-shift algorithm
    // vecteur pour stocker les différences entre les pixels et la moyenne
        std::vector<cv::Vec3b> diff  ;  
        while(!convergence){
        for(int i = 0; i < m.rows; i++){
            for (int j = 0; j <m.cols ; j++){
                //Obtentions de Sh(x)
                Mat Sh = submatrix(m, i,j, hs, hc);

                //Calcul de la moyenne des pixels de Sh(x)
                int moyenne = 0;
                int nb = 0;
                for (int i = 0; i < Sh.rows; i++) {
                    for (int j = 0; j < Sh.cols; j++) {
                        if (Sh.at<float>(i, j) != -1) {
                            moyenne += Sh.at<float>(i, j);
                            nb++;
                        }
                    
                    }
                }
                moyenne = moyenne / nb; 
                //Calcul de la différence entre le pixel et la moyenne
                if (abs(m.at<float>(i, j) - moyenne) > eps) {
                    diff.push_back(1);

                }
                else {
                    diff.push_back(0);
                }
                // x prend la valeur de la moyenne
                    m.at<float>(i, j) = moyenne;
    
            }

        }
        //k++
        k++;
        // vérification de la convergence: il existe au moins un pixel dont la différence est supérieure à eps et k < max
        if (diff.size() == 0 || k > 2) {
            convergence = true;
        }
        else {
            diff.clear();
        }
       

    
    
    }
        cout << "k = " << k << endl;

        return;

}

    
void printHelp(const string& progName)

{
    cout << "Usage:\n\t " << progName << " <image_file> <K_num_of_clusters> [<image_ground_truth>]" << endl;
}

int main(int argc, char** argv)
{

    const auto imageFilename = string(argv[1]);
     const string groundTruthFilename = (argc == 4) ? string(argv[3]) : string();


    //just for debugging
    {
        cout << " Program called with the following arguments:" << endl;
        cout << " \timage file: " << imageFilename << endl;
        if(!groundTruthFilename.empty()) cout << " \tground truth segmentation: " << groundTruthFilename << endl;
    }

    Mat m= imread(imageFilename, IMREAD_COLOR);
    
    // convertir en espace couleur L*a*b
     cvtColor(m, m, COLOR_BGR2Lab);
    cout << m.at<Vec3b>(0,0) << endl;


    //on définit les paramètres pour meanshift
    TermCriteria termcrit(TermCriteria::MAX_ITER | TermCriteria::EPS, 5, 1);
    int spatialRad = 10;
    int colorRad = 20;
    int maxPyrLevel = 20;
    Mat result=m;
    //on applique meanshift
    //pyrMeanShiftFiltering(m, result, spatialRad, colorRad, maxPyrLevel, termcrit);
    meanshift(m,spatialRad, colorRad, maxPyrLevel,  0.0001);
    // affichage de k 
    cvtColor(m, m, COLOR_Lab2BGR);
    imwrite("meanshift.jpg", m);
    namedWindow(imageFilename, cv::WINDOW_AUTOSIZE);
    namedWindow("kmeans image", cv::WINDOW_AUTOSIZE);
    imshow(imageFilename, imread(imageFilename));
    imshow("Segmented Image", m);
   cv::waitKey(0);

    return 0;
    }


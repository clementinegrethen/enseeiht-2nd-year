using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

//////////////////////////////////////////////////////////////////////////
///////////////// Classe qui gère la subdivision via DCJ /////////////////
//////////////////////////////////////////////////////////////////////////
public class DeCasteljauSubdivision : MonoBehaviour
{
    // Pas d'échantillonage pour affichage
    public float pas = 1 / 100;
    // Nombre de subdivision dans l'algo de DCJ
    public int NombreDeSubdivision = 3;
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués
    public GameObject Donnees;
    // Coordonnees des points composant le polygone de controle
    private List<float> PolygoneControleX = new List<float>();
    private List<float> PolygoneControleY = new List<float>();

    //////////////////////////////////////////////////////////////////////////
    // fonction : DeCasteljauSub                                            //
    // semantique : renvoie la liste des points composant la courbe         //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - int nombreDeSubdivision : nombre de subdivision           //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : liste des abscisses et liste //
    //            des ordonnées des points composant la courbe              //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) DeCasteljauSub(List<float> X, List<float> Y, int nombreDeSubdivision)
    {
        // création des listes intermédiares et de sortie
        List<float> XSortie = new List<float>(X);
        List<float> YSortie = new List<float>(Y);

        List<float> xQ = new List<float>();
        List<float> yQ = new List<float>();
        List<float> xR = new List<float>();
        List<float> yR = new List<float>();
        // coefficient de subdivision 
        float t = 0.5f; 
        for(int sub=0; sub<nombreDeSubdivision; sub++){
            // on vide les listes intermédiaires
            xQ.Clear();
            yQ.Clear();
            xR.Clear();
            yR.Clear();
            // on ajoute les points de controle de la courbe de départ
            // Pour Q le premier point est le premier point de la courbe de départ
            // Pour R le premier point est le dernier point de la courbe de départ
            xQ.Add(XSortie[0]);
            yQ.Add(YSortie[0]);
            xR.Add(XSortie[XSortie.Count-1]);
            yR.Add(YSortie[YSortie.Count-1]);
            // calcul des points intermédaires 
            for (int ligne=0 ; ligne < YSortie.Count-1; ligne++) {
                for(int col=0; col < YSortie.Count-ligne-1; col++){
                    // Application de la formule de De Casteljau pour chaque point
                    YSortie[col] = (1 - t) * YSortie[col] + t * YSortie[col+1];
                    XSortie[col] = (1 - t) * XSortie[col] + t * XSortie[col+1];
                }
                // Ajout des points intermédiaires dans les listes gauche et droite
                xQ.Add(XSortie[0]);
                yQ.Add(YSortie[0]);
                xR.Add(XSortie[YSortie.Count-ligne-2]);
                yR.Add(YSortie[YSortie.Count-ligne-2]);
            }
            // on vide la liste de sortie pour qu'elle contienne les nouveaux points
            XSortie.Clear();
            // on inverse les listes droite et gauche pour que la courbe soit dans le bon sens
            xR.Reverse();
            // on ajoute les points de la courbe de gauche puis de droite
            XSortie.AddRange(xQ);
            XSortie.AddRange(xR);
            YSortie.Clear();
            yR.Reverse();
            YSortie.AddRange(yQ);
            YSortie.AddRange(yR);
            // on recommence avec les nouveaux points de controle pour recréer deux "familles" de points Q et R
        }

        return (XSortie, YSortie);
    }


    //////////////////////////////////////////////////////////////////////////
    //////////////////////////// NE PAS TOUCHER //////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    void Start()
    {

    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            var ListePointsCliques = GameObject.Find("Donnees").GetComponent<Points>();
            if (ListePointsCliques.X.Count > 0)
            {
                for (int i = 0; i < ListePointsCliques.X.Count; ++i)
                {
                    PolygoneControleX.Add(ListePointsCliques.X[i]);
                    PolygoneControleY.Add(ListePointsCliques.Y[i]);
                }
                List<float> XSubdivision = new List<float>();
                List<float> YSubdivision = new List<float>();

                (XSubdivision, YSubdivision) = DeCasteljauSub(ListePointsCliques.X, ListePointsCliques.Y, 3);
                for (int i = 0; i < XSubdivision.Count; ++i)
                {
                    ListePoints.Add(new Vector3(XSubdivision[i], -4.0f, YSubdivision[i]));
                }
            }

        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        for (int i = 0; i < PolygoneControleX.Count - 1; ++i)
        {
            Gizmos.DrawLine(new Vector3(PolygoneControleX[i], -4.0f, PolygoneControleY[i]), new Vector3(PolygoneControleX[i + 1], -4.0f, PolygoneControleY[i + 1]));
        }

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}

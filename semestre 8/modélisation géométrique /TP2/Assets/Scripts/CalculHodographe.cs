using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CalculHodographe : MonoBehaviour
{
    // Nombre de subdivision dans l'algo de DCJ
    public int NombreDeSubdivision = 3;
    // Liste des points composant la courbe de l'hodographe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués

    public GameObject Donnees;
    public GameObject particle;

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
    // fonction : Hodographe                                                //
    // semantique : renvoie la liste des vecteurs vitesses entre les paires //
    //              consécutives de points de controle                      //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - float Cx : offset d'affichage en x                        //
    //          - float Cy : offset d'affichage en y                        //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : listes composantes des       //
    //            vecteurs vitesses sous la forme (Xs,Ys)                   //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) Hodographe(List<float> X, List<float> Y, float Cx = 1.5f, float Cy = 0.0f)
    {
         List<float> XSortie = new List<float>();
        List<float> YSortie = new List<float>();

        for (int i = 0; i < X.Count - 1; i++)
        {
            // Calcul de la différence entre les points de contrôle consécutifs
            float deltaX = (X[i + 1] - X[i])*X.Count;
            float deltaY = (Y[i + 1] - Y[i])*X.Count;
            // Ajout des différences à la liste de sortie EN AJOUTANT LES OFFSETS
            deltaX += Cx;
            deltaY += Cy;
            // on calcul les vecteurs vitesse entre les points de controle
            XSortie.Add(deltaX);
            YSortie.Add(deltaY);

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
            Instantiate(particle, new Vector3(1.5f, -4.0f, 0.0f), Quaternion.identity);
            var ListePointsCliques = GameObject.Find("Donnees").GetComponent<Points>();
            if (ListePointsCliques.X.Count > 0)
            {
                List<float> XSubdivision = new List<float>();
                List<float> YSubdivision = new List<float>();
                List<float> dX = new List<float>();
                List<float> dY = new List<float>();
                
                (dX, dY) = Hodographe(ListePointsCliques.X, ListePointsCliques.Y);

                (XSubdivision, YSubdivision) = DeCasteljauSub(dX, dY, NombreDeSubdivision);
                for (int i = 0; i < XSubdivision.Count; ++i)
                {
                    ListePoints.Add(new Vector3(XSubdivision[i], -4.0f, YSubdivision[i]));
                }
            }

        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}

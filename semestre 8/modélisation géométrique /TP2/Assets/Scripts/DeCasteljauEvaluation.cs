using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//////////////////////////////////////////////////////////////////////////
///////////////// Classe qui gère l'évaluation via DCJ ///////////////////
//////////////////////////////////////////////////////////////////////////
public class DeCasteljauEvaluation : MonoBehaviour
{
    // Pas d'échantillonage construire la parametrisation
    public float pas = 1 / 100;
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués
    public GameObject Donnees;
    // Coordonnees des points composant le polygone de controle
    private List<float> PolygoneControleX = new List<float>();
    private List<float> PolygoneControleY = new List<float>();
    
    //////////////////////////////////////////////////////////////////////////
    // fonction : buildEchantillonnage                                       //
    // semantique : construit un échantillonnage regulier                    //
    // params : aucun                                                      //
    // sortie :                                                             //
    //          - List<float> tToEval : échantillonnage regulier             //
    //////////////////////////////////////////////////////////////////////////
    List<float> buildEchantillonnage()
    {
        List<float> tToEval = new List<float>();
        for (float t = 0.0f; t <= 1; t = t + pas)
        {
            tToEval.Add(t);
        }
        return tToEval;
    }

   //////////////////////////////////////////////////////////////////////////
    // fonction : DeCasteljau                                               //
    // semantique : renvoie le point approxime via l'aglgorithme de DCJ     //
    //              pour une courbe définie par les points de controle      //
    //              (X,Y) à l'instant t                                     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - float t : temps d'approximation                           //
    // sortie :                                                             //
    //          - Vector2 : point atteint au temps t                        //
    //////////////////////////////////////////////////////////////////////////
    Vector2 DeCasteljau(List<float> X, List<float> Y, float t)
    {
         // Interpolation de Neville
        List<float> Xi = new List<float>();
        List<float> Yi = new List<float>();
        for (int i = 0; i < X.Count; ++i)
        {
            Xi.Add(X[i]);
            Yi.Add(Y[i]);
        }
        // On parcourt les différentes paires de points nécessaires pour effectuer l'interpolation.
        for (int i = 1; i < X.Count; ++i)
        {
            for (int j = 0; j < X.Count - i; ++j)
            {
                Xi[j] = (((1-t) * Xi[j] + (t) * Xi[j + 1]) ;
                Yi[j] = ((1-t)* Yi[j] + (t) * Yi[j + 1]);
            }
        }
        // on renvoie le point atteint en t
        return new Vector2(Xi[0], Yi[0]);
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

                List<float> T = buildEchantillonnage();
                Vector2 point = new Vector2();
                foreach (float t in T)
                {
                    point = DeCasteljau(ListePointsCliques.X, ListePointsCliques.Y, t);
                    ListePoints.Add(new Vector3(point.x,-4.0f,point.y));
                }
            }
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        for (int i = 0; i < PolygoneControleX.Count - 1; ++i)
        {
            Gizmos.DrawLine(new Vector3(PolygoneControleX[i],-4.0f, PolygoneControleY[i]), new Vector3(PolygoneControleX[i + 1], -4.0f, PolygoneControleY[i + 1]));
        }

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}

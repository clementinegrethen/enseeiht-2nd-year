using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CourbesFermees : MonoBehaviour
{
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués
    public GameObject Donnees;
    // Coordonnees des points composant le polygone de controle
    private List<float> PolygoneControleX = new List<float>();
    private List<float> PolygoneControleY = new List<float>();

    // degres des polynomes par morceaux
    public int degres = 5;
    // nombre d'itération de subdivision
    public int nombreIteration = 5;

    //////////////////////////////////////////////////////////////////////////
    // fonction : subdivise                                                 //
    // semantique : réalise nombreIteration subdivision pour des polys de   //
    //              degres degres                                           //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : points de la courbe          //
    //////////////////////////////////////////////////////////////////////////
    // (List<float>, List<float>) subdivise(List<float> X, List<float> Y) {
    //     List<float> Xres = new List<float>();
    //     List<float> Yres = new List<float>();

    //     // Duplication des points de contrôle pour obtenir un polygone fermé
    //     // CF poly moodle tp3 subdisvion 
    //     foreach (float x in X)
    //     {
    //         Xres.Add(x);
    //         Xres.Add(x);
    //     }
    //     foreach (float y in Y)
    //     {
    //         Yres.Add(y);
    //         Yres.Add(y);
    //     }

    //     for (int i = 0; i < nombreIteration; i++)
    //     {
    //         for (int j = 0; j < Xres.Count - 1; j++)
    //         {
    //             // Calcul du point milieu entre deux points de contrôle consécutifs dans le polygone de contrôle
    //             Xres[j] = (Xres[j] + Xres[j + 1]) / 2;
    //             Yres[j] = (Yres[j] + Yres[j + 1]) / 2;
    //         }

    //         // Calcul du point milieu entre le premier et le dernier point de contrôle
    //         Xres.Add((Xres[0] + Xres[Xres.Count - 1]) / 2);
    //         Yres.Add((Yres[0] + Yres[Yres.Count - 1]) / 2);
    //     }

    //     return (Xres, Yres);

        
    // }
    // Spline
    (List<float>, List<float>) subdivise(List<float> X, List<float> Y)
    {
        List<float> Xres = new List<float>(X);
        List<float> Yres = new List<float>(Y);

        for (int k = 0; k < nombreIteration; k++)
        {
            List<float> Xk = new List<float>();
            List<float> Yk = new List<float>();
           

            // Initialisation des points de controle
            for (int i = 0; i < Xres.Count; i++)
            {
                // Ajouté deux fois pour pouvoir faire la moyenne
                Xk.Add(Xres[i]);
                Xk.Add(Xres[i]);
                Yk.Add(Yres[i]);
                Yk.Add(Yres[i]);
                
            }
            
            for (int i = 0; i < degres; i++)
            {
                for (int j = 0; j < Xk.Count -1; j++)
                {
                    Xk[j] = (Xk[j+1] + Xk[j]) * 0.5f;
                    Yk[j] = (Yk[j+1] + Yk[j]) * 0.5f;
                   
                }

                // Ajout du dernier point
                Xk.Add((Xk[Xk.Count - 1] + Xk[0]) * 0.5f);
                Yk.Add((Yk[Yk.Count - 1] + Yk[0]) * 0.5f);
                
            }

            Xres = Xk;
            Yres = Yk;
            
        }
        return (Xres, Yres);
    }

    //////////////////////////////////////////////////////////////////////////
    //////////////////////////// NE PAS TOUCHER //////////////////////////////
    //////////////////////////////////////////////////////////////////////////

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
                
                List<float> Xres = new List<float>();
                List<float> Yres = new List<float>();

                (Xres, Yres) = subdivise(ListePointsCliques.X,ListePointsCliques.Y);
                for (int i = 0; i < Xres.Count; ++i) {
                    ListePoints.Add(new Vector3(Xres[i],-4.0f,Yres[i]));
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
        if (PolygoneControleX.Count > 0 ) {
            Gizmos.DrawLine(new Vector3(PolygoneControleX[PolygoneControleX.Count - 1],-4.0f, PolygoneControleY[PolygoneControleY.Count - 1]), new Vector3(PolygoneControleX[0], -4.0f, PolygoneControleY[0]));
        }

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
        if (ListePoints.Count > 0 ) {
            Gizmos.DrawLine(ListePoints[ListePoints.Count - 1], ListePoints[0]);
        }
    }
}

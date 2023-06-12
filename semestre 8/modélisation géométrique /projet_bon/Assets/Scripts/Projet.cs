using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;
using UnityEngine.UI;

public class Projet : MonoBehaviour
{
    // Choix du mode de calcul
    public enum Mode { Spline, Neville};
    public Mode Type = Mode.Spline;
    
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    private List<Vector3> ListePointsSub = new List<Vector3>();
    private List<Quaternion> ListeQuaternions = new List<Quaternion>();
    private List<Quaternion> ListeQuaternionsSub = new List<Quaternion>();

    public GameObject particle;

    // Coordonnees des points composant le polygone de controle
    private List<float> PX = new List<float>();
    private List<float> PY = new List<float>();
    private List<float> PZ = new List<float>();

    // Pas d'echantillonnage
    public float pas = 1/100;

    // Degres des polynomes par morceaux
    public int degres = 5;
    // Nombre de subdivisions
    public int nombreIteration = 5;

    public int nb = 0;
    public Quaternion rotation;

    // Echantillonnage
    (List<float>, List<float>) buildParametrisationTchebycheff(int nbElem, float pas)
    {
        // Vecteur des pas temporels
        List<float> T = new List<float>();
        // Echantillonage des pas temporels
        List<float> tToEval = new List<float>();

        // Construction des pas temporels
        for (int i = 0; i < nbElem; i++)
        {
            T.Add((float) Math.Cos(((2 * i + 1) * Math.PI) / (2 * (nbElem-1) + 2)));
        }

        // Construction des échantillons
        for (float t = T.Min(); t < T.Max(); t += pas)
        {
            tToEval.Add(t);
        }

        return (T, tToEval);
    }

    // Parametrisation Neville
    (List<float>, List<float>, List<float>, List<Quaternion>) applyNevilleParametrisation(List<float> X, List<float> Y, List<float> Z, List<Quaternion> Q, List<float> T, List<float> tToEval)
    {
        // Liste des points de la courbe
        List<float> Xcourbe = new List<float>();
        List<float> Ycourbe = new List<float>();
        List<float> Zcourbe = new List<float>();
        List<Quaternion> Qcourbe = new List<Quaternion>();

        for (int i = 0; i < tToEval.Count; ++i)
        {
            // Appliquer neville a l'echantillon i
            (Vector3 v, Quaternion q) = neville(X, Y, Z, Q, T, tToEval[i]);
            Xcourbe.Add(v.x);
            Ycourbe.Add(v.y);
            Zcourbe.Add(v.z);
            Qcourbe.Add(q);
        }

        return (Xcourbe, Ycourbe, Zcourbe, Qcourbe);
    }

    // Neville
   private (Vector3, Quaternion) neville(List<float> X, List<float> Y, List<float> Z, List<Quaternion> Q, List<float> T, float t)
{
    List<float> Xi = new List<float>(X);
    List<float> Yi = new List<float>(Y);
    List<float> Zi = new List<float>(Z);
    List<Quaternion> Qi = new List<Quaternion>(Q);

    for (int j = 1; j < X.Count; j++)
    {
        for (int k = 0; k < X.Count - j; k++)
        {
            Xi[k] = (T[k + j] - t) / (T[k + j] - T[k]) * Xi[k] + (t - T[k]) / (T[k + j] - T[k]) * Xi[k + 1];
            Yi[k] = (T[k + j] - t) / (T[k + j] - T[k]) * Yi[k] + (t - T[k]) / (T[k + j] - T[k]) * Yi[k + 1];
            Zi[k] = (T[k + j] - t) / (T[k + j] - T[k]) * Zi[k] + (t - T[k]) / (T[k + j] - T[k]) * Zi[k + 1];
            // Interpolation des quaternions par slerp 
            Qi[k] = Quaternion.Slerp(Qi[k], Qi[k+1], (t - T[k]) / (T[k + j] - T[k]));
            Qi[k] = Quaternion.Normalize(Qi[k]);  // Normalise the quaternion
        }
    }
    return (new Vector3(Xi[0], Yi[0], Zi[0]), Qi[0]);
}

    
    // Spline
    (List<float>, List<float>, List<float>, List<Quaternion>) subdivise(List<float> X, List<float> Y, List<float> Z, List<Quaternion> Q)
    {
        List<float> Xres = new List<float>(X);
        List<float> Yres = new List<float>(Y);
        List<float> Zres = new List<float>(Z);
        List<Quaternion> Qres = new List<Quaternion>(Q);

        for (int k = 0; k < nombreIteration; k++)
        {
            List<float> Xk = new List<float>();
            List<float> Yk = new List<float>();
            List<float> Zk = new List<float>();
            List<Quaternion> Qk = new List<Quaternion>();

            // Initialisation des points de controle
            for (int i = 0; i < Xres.Count; i++)
            {
                // Ajouté deux fois pour pouvoir faire la moyenne
                Xk.Add(Xres[i]);
                Xk.Add(Xres[i]);
                Yk.Add(Yres[i]);
                Yk.Add(Yres[i]);
                Zk.Add(Zres[i]);
                Zk.Add(Zres[i]);
                Qk.Add(Qres[i]);
                Qk.Add(Qres[i]);
            }
            
            for (int i = 0; i < degres; i++)
            {
                for (int j = 0; j < Xk.Count -1; j++)
                {
                    Xk[j] = (Xk[j+1] + Xk[j]) * 0.5f;
                    Yk[j] = (Yk[j+1] + Yk[j]) * 0.5f;
                    Zk[j] = (Zk[j+1] + Zk[j]) * 0.5f;
                    Qk[j] = Quaternion.Slerp(Qk[j], Qk[j + 1], 0.5f);
                }

                // Ajout du dernier point
                Xk.Add((Xk[Xk.Count - 1] + Xk[0]) * 0.5f);
                Yk.Add((Yk[Yk.Count - 1] + Yk[0]) * 0.5f);
                Zk.Add((Zk[Zk.Count - 1] + Zk[0]) * 0.5f);
                Qk.Add(Quaternion.Slerp(Qk[Qk.Count - 1], Qk[0], 0.5f));
            }

            Xres = Xk;
            Yres = Yk;
            Zres = Zk;
            Qres = Qk;
        }
        return (Xres, Yres, Zres, Qres);
    }

    void Start()
    {
        // Liste des points de la courbe
        GameObject[] ListeSpheres = GameObject.FindGameObjectsWithTag("Player");
        // Trier les points par ordre alphabetique
        Array.Sort(ListeSpheres, (x, y) => String.Compare(x.name, y.name));

        int n = ListeSpheres.Length;

        for (int i = 0; i < n; i++)
        {
            // Ajouter les points de la courbe
            Vector3 position_sphere = ListeSpheres[i].transform.position;
            ListePoints.Add(position_sphere);
            Instantiate(particle, ListePoints[i], Quaternion.identity);

            // Ajouter les quaternions
            Vector3 position_suivante = ListeSpheres[(i + 1) % n].transform.position;
            // On suit un chemin, on regarde donc vers la prochaine position
            Vector3 relativPos = position_suivante - position_sphere;
            ListeQuaternions.Add(Quaternion.LookRotation(relativPos,Vector3.up));
        }

        for (int i = 0; i < ListePoints.Count; i++)
        {
            // Polygone de controle
            PX.Add(ListePoints[i].x);
            PY.Add(ListePoints[i].y);
            PZ.Add(ListePoints[i].z);
        }

        List<float> Xres = new List<float>();
        List<float> Yres = new List<float>();
        List<float> Zres = new List<float>();
        List<float> T = new List<float>();
        List<float> tToEval = new List<float>();

        switch (Type) {
            case Mode.Spline :
                (Xres, Yres, Zres, ListeQuaternionsSub) = subdivise(PX, PY, PZ, ListeQuaternions);
                break;
            case Mode.Neville :
                (T, tToEval) = buildParametrisationTchebycheff(PX.Count, pas);
                (Xres, Yres, Zres, ListeQuaternionsSub) = applyNevilleParametrisation(PX, PY, PZ, ListeQuaternions, T, tToEval);
                break;
        }

        for (int i = 0; i < Zres.Count; i++)
        {
            // On ajoute les points qui forment la trajectoire
            ListePointsSub.Add(new Vector3(Xres[i], Yres[i], Zres[i]));
        }

    }

    void FixedUpdate()
    {
        if (nb<ListePointsSub.Count)
        {
            // Mis à jour de la position et de la rotation
            transform.position = ListePointsSub[nb];
            transform.rotation = ListeQuaternionsSub[nb];
        } else
        {
            switch (Type)
            {
                // Si on est en mode spline, on recommence la boucle
                case Mode.Spline:
                    nb = -1;
                    break;
                // Si on est en mode Neville, on s'arrete
                case Mode.Neville:
                    break;
            }
        } nb++;
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        for (int i = 0; i < ListePointsSub.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePointsSub[i], ListePointsSub[i + 1]);
        }
        if (ListePointsSub.Count > 0)
        {
            Gizmos.DrawLine(ListePointsSub[ListePointsSub.Count - 1], ListePointsSub[0]);
        } 

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
        if (ListePoints.Count > 0)
        {
            Gizmos.DrawLine(ListePoints[ListePoints.Count - 1], ListePoints[0]);
        }
    }
}

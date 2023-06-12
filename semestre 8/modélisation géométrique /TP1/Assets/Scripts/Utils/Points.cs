using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Permet de stocker les coordonnees des points selectionnes a l'écran en vue d'un traitement
public class Points : MonoBehaviour
{
    // Objet qui sera instancie sur un clic
    public GameObject particle;
    // Listes memoires des coordonnees
    public List<float> X = new List<float>();
    public List<float> Y = new List<float>();

    // Methode appellee a chaque pas de simulation
    void Update()
    {
        // Position de la souris
        Vector3 mousePos = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0f);
       
        // Si on clique
        if (Input.GetButtonDown("Fire1"))
        {
            //Debug.Log(mousePos);
            Vector3 wordPos;
            Ray ray = Camera.main.ScreenPointToRay(mousePos);
            Debug.Log("Ray");
            Debug.Log(ray);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 1000f))
            {
                Debug.Log("Hit");
                wordPos = hit.point;
                Debug.Log(wordPos);
            }
            else
            {
                 Debug.Log("no Hit");
                wordPos = Camera.main.ScreenToWorldPoint(mousePos);
                wordPos.y = 0f;
                Debug.Log(wordPos);
            }
            // On instancie un point sur le plan
            Instantiate(particle, wordPos, Quaternion.identity);
            X.Add(wordPos.x);
            Y.Add(wordPos.z);
        }
    }
}

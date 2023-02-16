import java.lang.reflect.*;
import java.util.*;
import java.io.*;
import java.lang.*;
import java.util.*;

/** L'objectif est de faire un lanceur simple sans utiliser toutes les clases
  * de notre architecture JUnit.   Il permet juste de valider la compréhension
  * de l'introspection en Java.
  */
public class LanceurIndependant {
	private int nbTestsLances;
	private int nbErreurs;
	private int nbEchecs;
	private List<Throwable> erreurs = new ArrayList<>();

	public LanceurIndependant(String... nomsClasses) {
	    System.out.println();

		// Lancer les tests pour chaque classe
		for (String nom : nomsClasses) {
			try {
				System.out.print(nom + " : ");
				this.testerUneClasse(nom);
				System.out.println();
			} catch (ClassNotFoundException e) {
				System.out.println(" Classe inconnue !");
			} catch (Exception e) {
				System.out.println(" Problème : " + e);
				e.printStackTrace();
			}
		}

		// Afficher les erreurs
		for (Throwable e : erreurs) {
			System.out.println();
			e.printStackTrace();
		}

		// Afficher un bilan
		System.out.println();
		System.out.printf("%d tests lancés dont %d échecs et %d erreurs.\n",
				nbTestsLances, nbEchecs, nbErreurs);
	}


	public int getNbTests() {
		return this.nbTestsLances;
	}


	public int getNbErreurs() {
		return this.nbErreurs;
	}


	public int getNbEchecs() {
		return this.nbEchecs;
	}


	private void testerUneClasse(String nomClasse)
		throws ClassNotFoundException, InstantiationException,
						  IllegalAccessException
	{
		// Récupérer la classe
		Class <?> classe_recupere= Class.forName(nomClasse);
		// Récupérer les méthodes "preparer" et "nettoyer"

		try {
			Method preparer = classe_recupere.getMethod("preparer");

			}catch (NoSuchMethodException e) {
			System.out.println(" preparer inconnue !");}
		
		try {
			Method nettoyer = classe_recupere.getMethod("nettoyer");
	
			}catch (NoSuchMethodException e) {
			System.out.println(" nettoyer inconnue !");}

		// Instancier l'objet qui sera le récepteur des tests
		try{
			
			ArrayList<Method> reception_testclass=new ArrayList<Method>();
			for (Method m: classe_recupere.getMethods()){
				String nameMethod=m.getName();
				System.out.println(nameMethod);

				if (nameMethod.startsWith("tester")){
					System.out.println("ok");
					reception_testclass.add(m);
					m.invoke(classe_recupere);
				}
			}
			Object objet= reception_testclass;
				
		}catch (IllegalArgumentException| InvocationTargetException |IllegalAccessException e){
			
		}
	
		
	}

	public static void main(String... args) {
		LanceurIndependant lanceur = new LanceurIndependant(args);
	}

}

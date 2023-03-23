package mypackage;

import java.util.ArrayList;

public class Personne {
	
	private static int idcount = 0;
	
	private int id;
	private String nom;
	private String prenom;
	private ArrayList<Adresse> adresses;
	
	public Personne(String nom, String prenom) {
		super();
		this.nom = nom;
		this.prenom = prenom;
		this.adresses = new ArrayList<Adresse>();
		this.id = idcount;
		idcount++;
	}
	
	public int getId() {
		return this.id;
	}
	
	public void ajouterAdresse(Adresse a) {
		this.adresses.add(a);
	}

	public String getNom() {
		return this.nom;
	}

	public String getPrenom() {
		return this.prenom;
	}
	
	public ArrayList<Adresse> getAdresses(){
		return this.adresses;
	}
	
}

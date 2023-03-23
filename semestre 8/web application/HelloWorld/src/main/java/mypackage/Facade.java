package mypackage;

import java.util.Collection;
import java.util.Hashtable;
import java.util.Map;

import javax.ejb.Singleton;
import javax.ws.rs.*;

@Singleton
public class Facade {
	
	private Map<Integer,Personne> personnes = new Hashtable<Integer,Personne>();
	private Map<Integer,Adresse> adresses = new Hashtable<Integer,Adresse>();
	
	
	public void ajoutPersonne(String nom, String prenom) {
		Personne personne = new Personne(nom,prenom);
		personnes.put(personne.getId(), personne);
	}
	
	public void ajoutAdresse(String rue, String ville) {
		Adresse adresse = new Adresse(rue,ville);
		adresses.put(adresse.getId(), adresse);
	}
	
	public Collection<Personne> listePersonnes(){
		return personnes.values();
		
	}
	public Collection<Adresse> listeAdresses(){
		return adresses.values();
		
	}
	public void associer(int personneId, int adresseId) {
		personnes.get(personneId).ajouterAdresse(adresses.get(adresseId));
		
	}

}

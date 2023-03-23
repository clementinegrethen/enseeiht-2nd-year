package mypackage;

public class Adresse {
	
	private static int idcount = 0;
	
	private int id;
	private String rue;
	private String ville;

	public Adresse(String rue, String ville) {
		super();
		this.rue = rue;
		this.ville = ville;
		this.id = idcount;
		idcount++;
	}

	public String getRue() {
		return this.rue;
	}

	public String getVille() {
		return this.ville;
	}
	
	public int getId() {
		return this.id;
	}
	
}

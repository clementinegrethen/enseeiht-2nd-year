import java.util.ArrayList;
import java.util.Vector;
import java.rmi.RemoteException;

/* 
 * @author: cgrethen lweisbec
 */

public class ServerObject implements ServerObject_ift {



    // Liste des clients ayant un verrou en lecture sur l'objet
    private ArrayList<Client_itf> lecteurs;
    // Client ayant un verrou en écriture sur l'objet
    private Client_itf ecrivain;
    // Objet partagé
    private Object obj;
    // Identifiant de l'objet partagé
    private int id;
    // Enumeration des différents états possibles pour un objet partagé
    public enum Enum_lock {NL, WL, RL};
    // Etat courant de l'objet partagé
    private Enum_lock lock;

    /**
     * Constructeur de la classe ServerObject
     * @param obj l'objet partagé
     * @param id l'identifiant de l'objet partagé
     */
    public ServerObject(Object obj, int id) {
        this.id = id;
        this.obj= obj;
		this.lock = Enum_lock.NL;
        this.lecteurs = new ArrayList<Client_itf>();
        this.ecrivain = null;

    }
    
	public synchronized Object lock_read(Client_itf client) {
		try {
			switch (this.lock) {
			case WL:
                this.obj= ecrivain.reduce_lock(id); // on enleve le verrou
                this.lecteurs.add(this.ecrivain); // on ajoute l'ecrivain a la liste des lecteurs pour le prochain verrou en lecture 
				break;
            default:break;
			}
			this.ecrivain = null; // on enleve l'ecrivain
			this.lecteurs.add(client); // on ajoute le lecteur
			this.lock = Enum_lock.RL; // on passe en mode lecture

		} catch (RemoteException e) {
			e.printStackTrace();
		}
		return obj;
	}

	/**
	 * Demande de verrou en ecriture 
	 * @param client le client qui a fait la demande
	 * @return Object l'objet partagé
	 */
	public synchronized Object lock_write(Client_itf client) {
		switch (this.lock) {
		case RL:
			this.lecteurs.remove(client);
            // on enleve le client de la liste des lecteurs
            for (Client_itf cli : this.lecteurs) {
				try {
					cli.invalidate_reader(this.id);
				} catch (Exception e) {
				}
			}break;
		case WL:
        // on enleve l'ecrivain
			try {
				this.obj= this.ecrivain.invalidate_writer(this.id);
			} catch (Exception e) {
			}
			break;

		default: break;
		}
		// on vide la liste des lecteurs car 
		this.lecteurs.clear(); this.ecrivain = client;this.lock = Enum_lock.WL; 
        return obj; 

	}
    
    



    public int getId() {
        return id;
    }

    
}

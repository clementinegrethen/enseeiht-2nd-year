import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.rmi.registry.*;
import java.net.*;
import java.util.HashMap;
import java.net.*;
/* 
 * @author: cgrethen lweisbec
 */

// On hérite de UnicastRemoteObject pour pouvoir être appelé par le serveur
public class Client extends UnicastRemoteObject implements Client_itf {
// client : son instance va être créée par init() et sera utilisée par les autres méthodes 
	private static Client_itf instance = null;
// serveur  : on va récupérer l'instance du serveur par lookup
	private static Server_itf server;
// hashmap des objets du client  : on va stocker les objets partagés localement
	private static HashMap<Integer, SharedObject> objets_client;

/**
 *  Constructeur de la classe Client
 * @throws RemoteException
 */

	public Client() throws RemoteException {
		super();
	}



/**
 * Initialisation du client
 */
	public static void init() {
		if (Client.instance == null) {
			try {
				Client.instance = new Client();
				// On récupère l'instance du serveur grâce au (vu en cours)
				// choix du port 9000 pour le serveur 
				server = (Server_itf) Naming.lookup("//localhost:9000/server");
				objets_client = new HashMap<Integer,SharedObject>();
			} catch (RemoteException | MalformedURLException | NotBoundException e) {
				e.printStackTrace();
			}
			System.out.println("Le client a été correctement initialisé.");

		}
	}
	
/**
	 * lookup : Récupère l'objet partagé de nom "nom"
	 * @param nom le nom de l'objet partagé
	 * @return l'objet partagé de nom "nom" ou null si l'objet n'existe pas
	 * @throws RemoteException
	 */	
	
	 public static SharedObject lookup(String nom) {
		SharedObject objet_recupere = null;
		int id = -1;
		try{
		// On récupère l'id de l'objet partagé
		id=server.lookup(nom);
		// Si l'id est -1, l'objet n'existe pas
		 if (id==-1){
			 return null;
		 }
		 // Si l'objet existe, on le récupère
		 	 objet_recupere= new SharedObject(id,lock_read(id));
			// On le dévérouille
			 objet_recupere.unlock();
			// On l'ajoute à la hashmap des objets partagés du client
			objets_client.put(id, objet_recupere);
			return  objet_recupere;

		 } catch (Exception e) {
			e.printStackTrace();
		 }
		 return objet_recupere;
	}		
	
	/**
	 *  register : Enregistre l'objet partagé "objet_enregistre" de nom "name" sur le serveur
	 * @param name : nom de l'objet partagé
	 * @param objet_enregistre : objet partagé à enregistrer 
	 * @throws RemoteException
	 */

	public static void register(String name, SharedObject_itf objet_enregistre) {
		try{
			// Il faur d'abord caster l'objet en SharedObject
			// On enregistre l'objet sur le serveur de nom "name" et on lui donne l'id de l'objet partagé
		server.register(name,((SharedObject) objet_enregistre).getId());
		} catch (RemoteException e) {
			e.printStackTrace();
		}
	}

	/**
	 *  create : Crée un objet partagé sur le serveur
	 * @param objet_creation : objet à partager
	 * @return l'objet partagé créé
	 * @throws RemoteException
	 */	
	public static SharedObject create(Object objet_creation) {
		SharedObject so = null;
		try {
			// On crée l'objet partagé sur le serveur
			// On va créer un serveur Object associé à un id en retour de create (dans la class ServerObject)
			// On ajoute cet objet dans la hashmap des serveurs objet (dans la class Server)
			// id correspond à l'id du serveur objet
			 so = new SharedObject(server.create(objet_creation), objet_creation);
			// on ajoute à la hashmap des objets partagés du client
			// l'objet et son identifiant associé ()
			// il est différent de id car id c'est l'identifiant du serveur objet
			// et l'autre id c'est celui de l'objet partagé(cf methode getId)
			// a voir je ne suis pas sur
			objets_client.put(so.getId(), so);

		} catch (RemoteException e) {
			e.printStackTrace();
		}
		return so;
	}
	

	/**
	 *  lock_read : Vérouille l'objet partagé en lecture
	 * @param id : identifiant de l'objet partagé à vérouiller en lecture
	 * @return l'objet partagé vérouillé en lecture
	 * @throws RemoteException
	 */
	public static Object lock_read(int id) {

		Object o = null;
		try {
			// On demande un lock en lecture au serveur en précisant au serveur le client qui demande le lock
			// un serveur rmi doit savoir qui est le client qui demande le lock
			 o = server.lock_read(id, instance);
			return o;

		}	catch (Exception e) {
			e.printStackTrace();
		}
		return o;

	}

	/**
	 *  lock_write : Vérouille l'objet partagé en écriture
	 * @param id : identifiant de l'objet partagé à vérouiller en écriture
	 * @return l'objet partagé vérouillé en écriture
	 * @throws RemoteException
	 */
	
	public static Object lock_write (int id) {
		Object o = null;
		try {
			// On demande un lock en écriture au serveur en précisant au serveur le client qui demande le lock
			// un serveur rmi doit savoir qui est le client qui demande le lock
			 o = server.lock_write(id, instance);
			return o;
		}	catch (Exception e) {
			e.printStackTrace();
		}
		return o;
	}

	/** 
	 * reduce_lock : Dévérouille l'objet partagé (on réduit le verrou)
	 * @param id : identifiant de l'objet partagé à dévérouiller
	 * @return l'objet partagé dévérouillé
	 */
	 
	public Object reduce_lock(int id) throws java.rmi.RemoteException {
		// On demande au serveur de réduire le lock 
		return objets_client.get(id).reduce_lock();

	}


	/**
	 * invalidate_reader : Demande au serveur d'invalidé le verrou en lecture
	 * @param id : identifiant de l'objet partagé à invalider
	 */
	public void invalidate_reader(int id) throws java.rmi.RemoteException {
		objets_client.get(id).invalidate_reader();

	}


/**
	 * invalidate_reader : Demande au serveur d'invalidé le verrou en écriture
	 * @param id : identifiant de l'objet partagé à invalider
	 */
		public Object invalidate_writer(int id) throws java.rmi.RemoteException {
		return objets_client.get(id).invalidate_writer(); 

	}
}


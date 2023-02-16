import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.rmi.registry.*;
import java.net.*;
import java.util.HashMap;
import java.net.*;
import java.lang.reflect.Constructor;
import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;
import java.util.HashMap;
import java.rmi.registry.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.net.*;



/**
 * Classe Client
 * 
 * @author cgrethen lweisbec
 *
 */
// On hérite de UnicastRemoteObject pour pouvoir être appelé par le serveur
public class Client extends UnicastRemoteObject implements Client_itf {

// client    
	private static Client_itf instance = null;
// serveur 
	private static Server_itf server;
// hashmap des objets du client 
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

	public static SharedObject lookup(String name) {
		SharedObject objet_recupere = null;
		int id = -1;
		try{
			// On récupère l'id de l'objet partagé
		  id=server.lookup(name);
		// Si l'id est -1, l'objet n'existe pas

		 if (id==-1){
			 return null;
		 }
		            Object obj = server.lock_read(id, instance);
					// On génère le stub de l'objet partagé et on l'enregistre dans la hashmap
					// le stub permet de faire des appels distants sur l'objet partagé
					StubGenerator.generateStub(obj);
					// On récupère le stub de l'objet partagé
					String className = obj.getClass().getSimpleName() + "_stub";
					// On récupère la classe du stub
					Class<?> classe = Class.forName(className);
					// On récupère le constructeur de la classe du stub
					Constructor<?> cons = classe.getConstructor(new Class[] {Object.class, int.class});
					// On crée l'objet partagé
					SharedObject object = (SharedObject) cons.newInstance(null, id);
					objets_client.put(id, object);
					return object;

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
	
	// Enregistremet du sharedObject so sur le serveur
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
		try {
			// On crée l'objet partagé sur le serveur et on récupère son id
			int id_objet= server.create(objet_creation);
			// On génère le stub de l'objet partagé et on l'enregistre dans la hashmap
			StubGenerator.generateStub(objet_creation);
			// On récupère le stub de l'objet partagé
			String className = objet_creation.getClass().getSimpleName() + "_stub";
			// On récupère la classe du stub
			Class<?> classe = Class.forName(className);
			// On récupère le constructeur de la classe du stub
			Constructor<?> cons = classe.getConstructor(new Class[] {Object.class, int.class});
			// On crée l'objet partagé
			SharedObject object = (SharedObject) cons.newInstance(objet_creation, id_objet);

			objets_client.put(id_objet, object);
			return object;
			

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
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
		// On demande un lock en écriture au serveur en précisant au serveur le client qui demande le lock
		// un serveur rmi doit savoir qui est le client qui demande le lock
		Object o = null;
		try {
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



import java.net.MalformedURLException;
import java.rmi.AlreadyBoundException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;

// server RMI class 
// Syntaxe vu dans le cours
public class server extends UnicastRemoteObject implements Server_itf {

    // HashMap qui contient les objets partagés
    private static HashMap<Integer, ServerObject> serverObjects;
    // HashMap pour le registre de noms (nom du server object, id du serveur object )
    // pemret au client de retrouver l'objet partagé
    private static HashMap<String,Integer> registre;
    // id en cours pour pouvoir assurer l'unicité des id des objets partagés
    private static  int id_en_cours;

    /**
     *  Constructeur du serveur RMI
     * @throws RemoteException
     */
    protected server() throws RemoteException {
        super();
        serverObjects = new HashMap<Integer, ServerObject>();
        registre = new HashMap<String, Integer>();
        id_en_cours=0;
    }

    /**
     * Création d'un objet partagé
     * @param o l'objet à partager à créer
     * @return l'id de l'objet partagé
     * @throws RemoteException
     */
    public int create (Object obj ) throws  RemoteException {
        // Création d'un objet partagé
         ServerObject serveur_obj = new ServerObject(obj,id_en_cours);
        // Ajout de l'objet partagé dans la HashMap
        serverObjects.put(id_en_cours, serveur_obj);
        // Incrémentation de l'id en cours
        id_en_cours++;
        // Retourne l'id de l'objet partagé (on met moins 1 car on a incrémenté l'id en cours)
        return (id_en_cours-1);
    }

    /** 
     * Méthode pour mettre un verrou en écriture sur un objet partagé
     * @param id l'id de l'objet partagé
     * @param client le client qui veut mettre le verrou
     * @return l'objet partagé
     * @throws RemoteException
     */
    public Object lock_write(int id,Client_itf client) throws java.rmi.RemoteException{
        Object obj = null;
		ServerObject so = serverObjects.get(id);
		if(so!=null){
			obj = so.lock_write(client);
		} else {
			System.err.println("erreur d'id pour le lock write");
		}
		return obj;
	}

    /** 
     * Méthode pour mettre un verrou en lecture sur un objet partagé
     * @param id l'id de l'objet partagé
     * @param client le client qui veut mettre le verrou
     * @return l'objet partagé
     * @throws RemoteException
     */

    public Object lock_read(int id,Client_itf client) throws java.rmi.RemoteException{
        Object obj = null;
        ServerObject serveur_obj = serverObjects.get(id);
        if(serveur_obj != null){
			obj = serveur_obj.lock_read(client);
		} else {
			System.err.println("erreur d'id pour le lock read");
		}
		return obj;
                                   
    }

    /**
     * Enregistrement d'un objet partagé dans le serveyr
     * @param name le nom de l'objet partagé
     * @param id l'id de l'objet partagé
     * @throws RemoteException
     */
	public void register(String name, int id) throws java.rmi.RemoteException{
        if (registre.containsKey(name)) {
            System.out.println("objet existant");
        } else {
            registre.put(name, id);
        }
    }

    /**
     *  lookup: permet de retrouver l'id d'un objet partagé à partir de son nom
     * @param name le nom de l'objet partagé
     * @return l'id de l'objet partagé
     * @throws RemoteException
     */
    public int lookup (String name) throws RemoteException{
        Integer id = registre.get(name);
        if (id!=null){
            return id;
        }
        return (-1);
    }

    // Méthode main pour lancer le serveur
public static void main(String[] args) throws MalformedURLException, RemoteException, AlreadyBoundException {
    System.out.println("Serveur est en cours d'exécution ...");

    try {
        // Création du registre de noms sur le port 9000 (vu en cours)
        Registry registre = LocateRegistry.createRegistry(9000);
    } catch (RemoteException e) {
        System.out.println("Erreur de création du registre de noms");
        e.printStackTrace();
    }
        Naming.bind("//localhost:9000/server", new server());
        System.out.println("le serveur est prêt");
    }
}


    


    

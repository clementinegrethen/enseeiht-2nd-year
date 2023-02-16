import java.io.*;

/**
 * @author cgrethen lweisbec
 * 
 */
// Un SharedObject est sérialisable car il est envoyé par RMI
public class SharedObject implements Serializable, SharedObject_itf {


	protected Object obj;

	// L'id du sharedObject
	private int id;
	// Enumération des différents états du verrou
	public enum Enum_lock {NL, RLC, WLC, RLT, WLT, RLT_WLC};

	private boolean stop;

	// lock est l'état courant du verrou
	private Enum_lock lock;

	/**
	 * Le constructeur de  SharedObject
	 * @param id  l'identifiant du SharedObject
	 * @param object l'objet partagé
	 */
	public SharedObject(int id, Object object) {
		super();
		this.id = id;
		this.obj = object;
		this.lock = Enum_lock.NL;
		this.stop = false;
	}

	
	public void lock_write() {
		//
		boolean lockwriteget = false;
		// moniteur sur l'objet
		synchronized (this) {
			while (this.stop) {
				try {
					wait();
				} catch (InterruptedException e) {
				}
			}
			switch (this.lock) {
			case NL:
			lockwriteget = true;
			this.lock = Enum_lock.WLT; break;
			case RLC:
				lockwriteget = true;
				this.lock = Enum_lock.WLT; 
				break;
			case WLC:
				this.lock = Enum_lock.WLT; 
				break;
			default:
			System.out.println("Erreur lock_write");
				break;
			}
		}
		// On sort du moniteur pour éviter les problèmes de concurrence
		// On appelle la méthode lock_write du client: cf sujet
		// car si on était dans l'état NL : pas encore de verrou lock_write: besoin de demander : en passant par le client
		if (lockwriteget) {
			this.obj = Client.lock_write(this.id);
		}
	}


	/**
	 * Verrouille en lecture l'objet partagé
	 * 
	 */
	public void lock_read() {
		boolean maj = false;
		// On synchronise sur l'objet pour éviter les problèmes de concurrence
		// CF système concurrent : moniteur 
		synchronized (this) {
			// Tant que l'attribut stop est vrai, on wait().
			while (this.stop) {
				try {
					wait();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			switch (this.lock) {
			case NL:
				maj = true;
				this.lock = Enum_lock.RLT; 
				break;

			case RLC:
				this.lock = Enum_lock.RLT; 
				break;

			case WLC:
				this.lock = Enum_lock.RLT_WLC; 
				break;

			default:
			System.err.println("probleme pour le  lock_read");
			System.err.println(lock);
				break;
			}
		}
		if (maj) {
			
			this.obj = Client.lock_read(this.id);
		}
	}


	/**
	 * unlock : Déverouille le SharedObject
	 */
	public synchronized void unlock() {

		switch (this.lock) {

		case RLT:this.lock = Enum_lock.RLC; 
			break;
		case WLT:this.lock = Enum_lock.WLC; 
			break;
		case RLT_WLC: this.lock = Enum_lock.WLC;
			break;
		default:
		
			break;
		}
		try {
			notify(); // notifier les threads qui attendent
		} catch (Exception e) {

		}
	}


	/**
	 * Réduit le verrou 
	 * @return l'objet partagé
	 */
	
	public synchronized Object reduce_lock(){
		stop=true;
		while(lock == Enum_lock.WLT) {
			try {
				wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		switch (this.lock) {
			case WLC: this.lock = Enum_lock.RLC; break;
			case RLT_WLC: this.lock = Enum_lock.RLT;
			default : break;
		}
		stop=false;
		try {
			notify();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
}

	/**
	 * Invalide le verrou en lecture
	 */
	public synchronized void invalidate_reader() {
		this.stop = true; 
		while (this.lock == Enum_lock.RLT) {
			try {
				wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

		switch (this.lock) {
		
		case RLC: this.lock = Enum_lock.NL;break;
		default:
		break;
		}
		this.stop = false; 
		try {
			notify();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Invalide le SharedObject en écriture
	 * @return Object la dernière version de l'objet
	 */
	public synchronized Object invalidate_writer() {
			stop=true;
			while(lock ==Enum_lock.WLT|| lock == Enum_lock.RLT_WLC){
				try {
					wait();
				} catch (InterruptedException e) {}
			}
			switch (this.lock) {
			case WLC: this.lock = Enum_lock.NL; break;
			 
			default:
			 break;
			}
			stop=false;
			try {
				notify();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return obj;
	}
	

/**
	 * Methode pour objetnir l'identifiant du SharedObject
	 * @return l'identifiant du SharedObject
	 */
	public int getId() {
		return this.id;
	}
}

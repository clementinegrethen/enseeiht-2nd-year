import java.io.Serializable;

/**
 * @author Clémentine et Lisa 
 *
 */
// un serveur objet est sérialisable car il est envoyé par RMI
public interface ServerObject_ift{

		
		public Object lock_read(Client_itf client);

		public Object lock_write(Client_itf client);
		
		
}


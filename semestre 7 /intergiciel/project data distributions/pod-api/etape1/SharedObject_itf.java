import java.rmi.RemoteException;

/**
 * @author cgrethen lweisbec
 *
 */

public interface SharedObject_itf {
	public void lock_read() throws RemoteException;
	public void lock_write() throws RemoteException;
	public void unlock() throws RemoteException;
}
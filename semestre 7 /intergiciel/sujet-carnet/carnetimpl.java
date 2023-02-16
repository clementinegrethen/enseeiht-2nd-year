import java.util.HashMap;
import java.rmi.*;
import java.rmi.registry.*;
import java.rmi.server.*;
import java.util.*;
public class carnetimpl implements Carnet {

    private Map<String,RFiche> carnet;
	private int numServeur;
	private carnetimpl autreCarnet;

    /**
     * @param n
     */
    public carnetimpl (int n) {
    	this.carnet = new HashMap<String,RFiche>();
        this.numServeur=n;
        this.autreCarnet=null;

    }

    public void main(String args[]) {
    	try {
    		int n = Integer.parseInt(args[1]);
    		carnetimpl serv = new carnetimpl(n);
    		Registry registry = LocateRegistry.createRegistry(4000);
    		Naming.rebind("//localhost:4000/carnet"+n, serv);
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }

    public void  Ajouter(SFiche f) throws RemoteException {
        RFiche rf = new RFicheImpl(f.getNom(), f.getEmail());
		carnet.put(f.getNom(), rf);
    }  


    public RFiche Consulter(String n, boolean forward) throws RemoteException {
		try {
			RFiche rf = carnet.get(n);
			if (rf == null && forward) {
				if (autreCarnet == null) {
					autreCarnet = (carnetimpl) Naming.lookup("//localhost:4000/carnet"+(3-numServeur));
				}
				rf = autreCarnet.Consulter(n, false);
			}
			return rf;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}
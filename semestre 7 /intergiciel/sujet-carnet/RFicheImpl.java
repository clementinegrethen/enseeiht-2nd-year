import java.rmi.RemoteException;

public class RFicheImpl implements RFiche{
    private String nom;
    private String email;
    public RFicheImpl(String n, String e) {
        this.nom = n;
        this.email = e;
    }

    @Override
    public String getNom() throws RemoteException {
        return this.nom;
    }

    @Override
    public String getEmail() throws RemoteException {
        return this.email;
    }

}
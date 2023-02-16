

public class SFicheImpl implements SFiche  {

    String name;
    String email;
    public SFicheImpl(String n, String e) {
        this.name = n;
        this.email = e;
    }
    public String getNom() {
        // TODO Auto-generated method stub
        return this.name;
    }

    @Override
    public String getEmail() {
        // TODO Auto-generated method stub
        return this.email;
    }

    
}


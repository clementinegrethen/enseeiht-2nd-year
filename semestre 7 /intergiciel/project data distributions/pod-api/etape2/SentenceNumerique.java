import javax.lang.model.util.ElementScanner6;

public class SentenceNumerique implements java.io.Serializable {
	
	public int 		data;
	
	public SentenceNumerique() {
		this.data = 1;
	}
	
	public void write(int nb, int op) {
		if (op == 0) {
            data = data + nb;
        } else if (op == 1) {
            data = data - nb;
        } else if (op == 2) {
            data = data * nb;
        } else if (op == 3) {
            data = data / nb;
        } 
	}
	public int read() {
		return data;	
	}

}

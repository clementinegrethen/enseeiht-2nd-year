import javax.lang.model.util.ElementScanner6;

/* 
 * @author: cgrethen lweisbec
 */
// pour réaliser un test sur un objet partagé de type SentenceNumerique: traveiller sur des entiers
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

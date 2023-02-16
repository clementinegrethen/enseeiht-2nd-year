public class SentenceNumerique_stub extends SharedObject implements SentenceNumerique_itf, java.io.Serializable {

	public SentenceNumerique_stub(Object o, int id) {
		super(id, o);
	}
	public void write(int arg0, int arg1) {
		SentenceNumerique s = (SentenceNumerique) obj;
		s.write(arg0, arg1);
	}

	public int read() {
		SentenceNumerique s = (SentenceNumerique) obj;
		return s.read();
	}

}

import java.util.Scanner;
// tests avec un lecteur qui va lire sur un objet partagé de type SentenceNumerique: c'est à dire un objet partagé qui contient un nombre
// permet de vérifier que notre modèle fonctionne sur d'autres types d'objets partagés que des String
public class testNombreReader {

    static String myName;
    static SharedObject sentence;
    static boolean isReading = false;

    public static void main(String argv[]) throws Exception {

        if (argv.length != 1) {
            System.out.println("java Irc <name>");
            return;
        }
        myName = argv[0];
        
        Client.init();
      
        sentence = Client.lookup("IRCNUM");
        if (sentence == null) {
            sentence = Client.create(new SentenceNumerique());
            Client.register("IRCNUM", sentence);
        }

        Scanner sc = new Scanner(System.in);
        System.out.println("Appuyer 'start' pour commencer à lire et espace+entrée pour arrêter de lire");
        String input = sc.nextLine();
        while (!input.equals("stop")) {
            if (input.equals("start")) {
                isReading = true;
                new ActionReaderNumerique().start();
                input = sc.nextLine();
                while (isReading) {
                    if (System.in.available() > 0) {
                        if (System.in.read() == ' ') {
                            isReading = false;
                        }
                    }
                }
            }
            else {
                input = sc.nextLine();
            }
        }
    }
}

class ActionReaderNumerique extends Thread {

    @Override
    public void run() {
        while (testNombreReader.isReading) {
            try {
                sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            testNombreReader.sentence.lock_read();

            int s = ((SentenceNumerique) (testNombreReader.sentence.obj)).read();

            testNombreReader.sentence.unlock();

            System.out.println(s);
        }
    }
}

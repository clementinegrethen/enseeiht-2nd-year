import java.util.Random;
import java.util.Scanner;
// tests avec un lecteur qui va écrire sur un objet partagé de type SentenceNumerique: c'est à dire un objet partagé qui contient un nombre
// permet de vérifier que notre modèle fonctionne sur d'autres types d'objets partagés que des String
public class testNombreWriter {
    static String myName;
    static boolean flag = false;
    static SharedObject sentence;
    static Random generator = new Random();

    public static void main(String argv[]) {
        if (argv.length != 1) {
            System.out.println("java Irc <name>");
            return;
        }
        myName = argv[0];
        Client.init();
       
        SharedObject s = Client.lookup("IRCNUM");
        if (s == null) {
            s = Client.create(new SentenceNumerique());
            Client.register("IRCNUM", s);
        }
        sentence = s;

        Scanner scanner = new Scanner(System.in);
        System.out.println("Appuyer 's' pour commencer à écrire et espace+entrée pour arrêter d'écrire");
        while (true) {
            String input = scanner.nextLine();
            if (input.equals("s")) {
                flag = true;
                new ActionWriterThreadNumerique().start();
            } else if (input.equals(" ")) {
                flag = false;
            }
        }
    }
}

class ActionWriterThreadNumerique extends Thread {

    @Override
    public void run() {
        while (testNombreWriter.flag) {
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            int op = testNombreWriter.generator.nextInt(4);
            int nb = testNombreWriter.generator.nextInt(10)+1;
            testNombreWriter.sentence.lock_write();

            ((SentenceNumerique) (testNombreWriter.sentence.obj))
                    .write(nb, op);
            System.out.println("op: " + op + " nb: " + nb );
            testNombreWriter.sentence.unlock();
        }
    }
}

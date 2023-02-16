import java.util.Random;
import java.util.Scanner;
// Même test que pour l'étape 1 avec un objet partagé de type SentenceNumerique

public class testNombreWriter {
    static String myName;
    static boolean flag = false;
    static SentenceNumerique_itf sentence;
    static Random generator = new Random();

    public static void main(String argv[]) {
        if (argv.length != 1) {
            System.out.println("java Irc <name>");
            return;
        }
        myName = argv[0];
        Client.init();
      
        SentenceNumerique_itf s =(SentenceNumerique_itf) Client.lookup("IRCNUM");
        if (s == null) {
            s =(SentenceNumerique_itf) Client.create(new SentenceNumerique());
            Client.register("IRCNUM", s);
        }
        sentence = s;

        Scanner scanner = new Scanner(System.in);
        System.out.println("Press 's' to start writing and ' ' to stop");
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

            (testNombreWriter.sentence).write(nb, op);
            System.out.println("op: " + op + " nb: " + nb );

            testNombreWriter.sentence.unlock();
        }
    }
}


import java.util.Scanner;
// Même test que pour l'étape 1 avec un objet partagé de type SentenceNumerique

public class testNombreReader {


    static String myName;
    static SentenceNumerique_itf sentence;
    static boolean isReading = false;

    public static void main(String argv[]) throws Exception {

        if (argv.length != 1) {
            System.out.println("java Irc <name>");
            return;
        }
        myName = argv[0];
        Client.init();
    
        sentence =(SentenceNumerique_itf) Client.lookup("IRCNUM");
        if (sentence == null) {
            sentence = (SentenceNumerique_itf) Client.create(new SentenceNumerique());
            Client.register("IRCNUM", sentence);
        }

        Scanner sc = new Scanner(System.in);
        System.out.println("Enter 'start' to begin reading or 'stop' to stop reading:");
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

            int s = (testNombreReader.sentence).read();

            testNombreReader.sentence.unlock();

            System.out.println(s);
        }
    }
}

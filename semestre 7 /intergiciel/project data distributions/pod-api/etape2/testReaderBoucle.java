import java.util.Scanner;
// Même test que pour l'étape 1 avec un objet partagé de type Sentence

public class testReaderBoucle {

    static String myName;
    static Sentence_itf sentence;
    static boolean isReading = false;

    public static void main(String argv[]) throws Exception {

        if (argv.length != 1) {
            System.out.println("java Irc <name>");
            return;
        }
        myName = argv[0];
        Client.init();
        
         sentence =(Sentence_itf) Client.lookup("IRC");
        if (sentence == null) {
            sentence =(Sentence_itf) Client.create(new Sentence());
            Client.register("IRC", sentence);
        }

        Scanner sc = new Scanner(System.in);
        System.out.println("Enter 'start' to begin reading or 'stop' to stop reading:");
        String input = sc.nextLine();
        while (!input.equals("o")) {
            if (input.equals("start")) {
                isReading = true;
                new ActionReader().start();
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

class ActionReader extends Thread {

    @Override
    public void run() {
        while (testReaderBoucle.isReading) {
            try {
                sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            testReaderBoucle.sentence.lock_read();

            String s = (testReaderBoucle.sentence).read();

            testReaderBoucle.sentence.unlock();

            System.out.println(s);
        }
    }
}

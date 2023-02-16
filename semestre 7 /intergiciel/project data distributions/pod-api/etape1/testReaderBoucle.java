import java.util.Scanner;

public class testReaderBoucle {



    static String myName;
    static SharedObject sentence;
    static boolean isReading = false;
// test d'un lecteur en continu sur un objet partagé de type Sentence
    public static void main(String argv[]) throws Exception {

        if (argv.length != 1) {
            System.out.println("java Irc <name>");
            return;
        }
        myName = argv[0];
        // initialise le systeme
        Client.init();
        // look upl'irc dans le name server
        // si pas trouvé, le créer, et l'enregistrer dans le name server
        sentence = Client.lookup("IRC");
        if (sentence == null) {
            sentence = Client.create(new Sentence());
            Client.register("IRC", sentence);
        }

        Scanner sc = new Scanner(System.in);
        System.out.println("Entrer 'start' pour commencer à lire, espace + entrée pour arrêter");
        String input = sc.nextLine();
        while (!input.equals("stop")) {
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

            // vérouiller l'objet partagé en lecture
            testReaderBoucle.sentence.lock_read();

            // lire la valeur
            String s = ((Sentence) (testReaderBoucle.sentence.obj)).read();

            // dévérouiller l'objet partagé
            testReaderBoucle.sentence.unlock();

            // afficher la valeur
            // tout s'affiche sur la console du lecteur
            System.out.println(s);
        }
    }
}

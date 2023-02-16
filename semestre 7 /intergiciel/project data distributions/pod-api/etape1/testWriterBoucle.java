import java.util.Scanner;
// test d'un writer  en continu sur un objet partagé de type Sentence
public class testWriterBoucle {
    static String myName;
    static boolean flag = false;
    static SharedObject sentence;

    public static void main(String argv[]) {
        if (argv.length != 1) {
            System.out.println("java Irc <name>");
            return;
        }
        myName = argv[0];
        // initialise le système
        Client.init();
        // look up IRC dans le serveur de noms
        // si non trouvé, le créer, et l'enregistrer dans le serveur de noms
        SharedObject s = Client.lookup("IRC");
        if (s == null) {
            s = Client.create(new Sentence());
            Client.register("IRC", s);
        }
        sentence = s;

        Scanner scanner = new Scanner(System.in);
        System.out.println("appuyer sur 's' puis entrée pour écrire, puis sur espace pour arrêter");
        while (true) {
            String input = scanner.nextLine();
            if (input.equals("s")) {
                flag = true;
                new ActionWritterTerminal().start();
            } else if (input.equals(" ")) {
                flag = false;
            }
        }
    }
}

class ActionWritterTerminal extends Thread {

    @Override
    public void run() {
        int i = 0;
        while (testWriterBoucle.flag) {
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            //  lock l'objet en mode écriture
            testWriterBoucle.sentence.lock_write();

            // écrire dans l'objet partagé
            ((Sentence) (testWriterBoucle.sentence.obj))
                    .write(testWriterBoucle.myName + " wrote " + i++);

            // unlock l'objet
            testWriterBoucle.sentence.unlock();
        }
    }
}

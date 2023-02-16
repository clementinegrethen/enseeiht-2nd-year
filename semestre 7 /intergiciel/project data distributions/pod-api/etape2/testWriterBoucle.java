import java.util.Scanner;
// Même test que pour l'étape 1 avec un objet partagé de type Sentence
public class testWriterBoucle {
    static String myName;
    static boolean flag = false;
    static Sentence_itf sentence;

    public static void main(String argv[]) {
        if (argv.length != 1) {
            System.out.println("java Irc <name>");
            return;
        }
        myName = argv[0];
        Client.init();
        
        Sentence_itf s = (Sentence_itf)Client.lookup("IRC");
        if (s == null) {
            s = (Sentence_itf)Client.create(new Sentence());
            Client.register("IRC", s);
        }
        sentence = s;

        Scanner scanner = new Scanner(System.in);
        System.out.println("Ecrire 's' pour commencer à écrire, barre d'espace entrée pour arrêter");
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

            testWriterBoucle.sentence.lock_write();

             (testWriterBoucle.sentence).write(testWriterBoucle.myName + " wrote " + i++);

            testWriterBoucle.sentence.unlock();
        }
    }
}





import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Method;
import javax.tools.JavaCompiler;
import javax.tools.JavaFileObject;
import javax.tools.StandardJavaFileManager;
import javax.tools.ToolProvider;
import java.util.Arrays;
/**
 * Classe permettant de générer un stub à partir d'un objet
 * @author Clémentine et Lisa
 *
 */

public class StubGenerator {

    public static void generateStub(Object obj) throws IOException {
        String className = obj.getClass().getSimpleName();
        String currentPath = System.getProperty("user.dir");
        File currentFolder = new File(currentPath);
        File[] files = currentFolder.listFiles();
        //on regarde si le fichier stub existe déjà
        boolean stubFileExists = Arrays.stream(files)
                                       .anyMatch(f -> f.getName().equals(className + "_stub.java"));

        // Si le fichier stub n'existe pas, on le crée                             
        if (!stubFileExists) {
            File stubFile = new File(className + "_stub.java");
            // On écrit le contenu du fichier stub
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(stubFile))) {
                StringBuilder fileContent = new StringBuilder();
                fileContent.append("public class " + className + "_stub extends SharedObject implements ");
                fileContent.append(className + "_itf, java.io.Serializable {\n\n");
                fileContent.append("\tpublic " + className + "_stub(Object o, int id) {\n");
                fileContent.append("\t\tsuper(id, o);\n\t}\n");
                // On récupère les méthodes de l'interface
                Method[] methods = obj.getClass().getDeclaredMethods();
                for (Method method : methods) {
                    fileContent.append("\tpublic ");
                    fileContent.append(method.getReturnType().getSimpleName());
                    fileContent.append(" " + method.getName() + "(");
                    // On récupère les paramètres de la méthode
                    int nbArg = 0;
                    Class<?>[] parameters = method.getParameterTypes();
                    for (Class<?> param : parameters) {
                        fileContent.append(param.getSimpleName() + " arg" + nbArg);
                        if (nbArg != parameters.length - 1) {
                            fileContent.append(", ");
                        }
                        nbArg++;
                    }
                    fileContent.append(")");
//                   // On récupère les exceptions de la méthode
                    Class<?>[] exceptions = method.getExceptionTypes();
                    if (exceptions.length != 0) {
                        fileContent.append(" throws ");
                    }
                    int nbExc = 0;

                    for (Class<?> exc : exceptions) {
                        fileContent.append(exc.getName());
                        if (nbExc != exceptions.length - 1) {
                            fileContent.append(", ");
                        }
                        nbExc++;
                    }
                    // On écrit le corps de la méthode
                    fileContent.append(" {\n");
                    char varName = Character.toLowerCase(className.charAt(0));
                    fileContent.append("\t\t" + className + " " + varName + " = (" + className + ") obj;\n");
                    String param = "";
                    for (int i=0; i < nbArg; i++) {
                        param += "arg" + i;
                        if (i != nbArg-1) {
                            param += ", ";
                        }
                    }
                    // On vérifie si la méthode retourne quelque chose
                    if (!method.getReturnType().getSimpleName().equals("void")) {
                        fileContent.append("\t\treturn ");
                    } else {
                        fileContent.append("\t\t");
                    }
                    fileContent.append(varName + "." + method.getName() +"(" + param +");\n");

                    fileContent.append("\t}\n");

                }
                // On ferme la classe
                fileContent.append("}");
                bw.write(fileContent.toString());
                
            } catch (IOException e) {
           
                e.printStackTrace();
            }
            // Compilation du code généré
            // ATTENTION: LA COMPILATION NE FONCTIONNE PAS SUR TOUTES LES VERSIONS DE JAVA
            // S'ASSURER QUE LA VERSION DE JAVA UTILISEE EST UNE VERSION JDK
            // SI ce n'est pas le cas: une erreur NULLPOINTER sera levée (cela s'est produit sur une de nos machines de test)
            // Mais le code généré est correct et il faut faire ainsi: Lancer cette classe StubGenerator : elle va générer le fichier stub
            // Puis lancer la commande javac nomDuFichier_stub.java dans le terminal
            try {
            JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
            int result = compiler.run(null, null, null, "-d", ".", className + "_stub.java");
            if (result == 0) {
                System.out.println("Compilation ok ");
            } else {
                System.out.println("Compilation failed");
            }
            } catch (NullPointerException e) {
                System.out.println("La compilation ne fonctionne pas sur cette version de Java. Veuillez utiliser une version JDK, ou compiler le fichier stub généré manuellement. (il a été généré correctement.");
            }

            
            
            


        }
    }
}



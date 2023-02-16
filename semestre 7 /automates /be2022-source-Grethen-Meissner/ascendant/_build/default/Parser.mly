%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_ACCOUV UL_ACCFER
%token UL_EGAL
%token UL_POINTVIRGULE

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_NAME 
%token <string> UL_IDENT
%token <int> UL_ENTIER

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> record

/* Le non terminal document est l'axiome */
%start record

%% /* Regles de productions */

record : valeur UL_FIN { (print_endline "record : valeur UL_FIN") }

valeur : UL_IDENT { (print_endline "valeur : valeur UL_IDENT")}| UL_ENTIER { (print_endline "valeur : valeur UL_ENTIER")}| enregistrement { (print_endline "valeur : enregistrement")}

enregistrement : UL_ACCOUV UL_ACCFER { (print_endline "enregistrement : UL_ACCOUV UL_ACCFER")}| UL_ACCOUV champs UL_ACCFER { (print_endline "enregistrement : UL_ACCOUV champs UL_ACCFER")}

champs : UL_NAME UL_EGAL valeur  { (print_endline "champs : UL_NAME UL_EGAL valeur UL_POINTVIRGULE")}| UL_NAME UL_EGAL valeur UL_POINTVIRGULE champs { (print_endline "champs : UL_NAME UL_EGAL valeur UL_POINTVIRGULE champs")}


%%

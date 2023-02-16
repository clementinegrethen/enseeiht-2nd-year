%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_PAROUV UL_PARFER
%token UL_PT UL_VIRG
%token UL_DEDUCTION UL_COUPURE UL_FAIL UL_NEGATION

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_SYMBOLE
%token <string> UL_VARIABLE

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> programme

/* Le non terminal document est l'axiome */
%start programme

%% /* Regles de productions */

programme : regle suite_regle UL_FIN { (print_endline "programme:   ") }




regle : axiome { (print_endline "regle : axiome") }| deduction { (print_endline "regle : deduction") }

suite_regle : { (print_endline "suite_regle : vide") } | regle suite_regle { (print_endline "suite_regle : regle suite_regle") }

axiome: predicat UL_PT { (print_endline "axiome : predicat UL_PT") }

deduction : predicat UL_DEDUCTION element suite_elements UL_PT { (print_endline " deduction : predicat UL_DEDUCTION element suite_elements UL_PT ") }

element : predicat { (print_endline "element : predicat") } | UL_NEGATION predicat { (print_endline "element : UL_NEGATION predicat") }
%%

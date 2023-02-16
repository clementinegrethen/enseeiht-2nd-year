{

(* Partie recopiée dans le fichier CaML généré. *)
(* Ouverture de modules exploités dans les actions *)
(* Déclarations de types, de constantes, de fonctions, d'exceptions exploités dans les actions *)

  open Tokens 
  exception Printf

}

(* Déclaration d'expressions régulières exploitées par la suite *)
let chiffre = ['0' - '9']
let minuscule = ['a' - 'z']
let majuscule = ['A' - 'Z']
let alphabet = minuscule | majuscule
let alphanum = alphabet | chiffre | '_'
let commentaire =
  (* Commentaire fin de ligne *)
  "#" [^'\n']*
 let champ= minuscule alphabet*
 let variable = majuscule alphabet*
rule scanner = parse
  | ['\n' '\t' ' ']+					{ (scanner lexbuf) }
  | commentaire						{ (scanner lexbuf) }
| "{"							{ UL_ACCOUV::(scanner lexbuf) }
  | "}"							{ UL_ACCFER ::(scanner lexbuf) }
  | "="             { UL_EGAL ::(scanner lexbuf) }
  | ";"             { UL_POINTVIRGULE ::(scanner lexbuf) }
  | ('0' | (['1' - '9'] (chiffre)*)) as entier {UL_ENTIER (int_of_string entier) ::(scanner lexbuf) }
  | champ as texte        { UL_NAME (texte) ::(scanner lexbuf) }
  | variable as texte       { UL_IDENT (texte) ::(scanner lexbuf) }
  | eof							{ [UL_FIN] }
  | _ as texte				 		{ (print_string "Erreur lexicale : ");(print_char texte);(print_newline ()); (UL_ERREUR::(scanner lexbuf)) }

{

}

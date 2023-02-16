open Tokens

(* Type du résultat d'une analyse syntaxique *)
type parseResult =
  | Success of inputStream
  | Failure
;;

(* accept : token -> inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien le token attendu *)
(* et avance dans l'analyse si c'est le cas *)
let accept expected stream =
  match (peekAtFirstToken stream) with
    | token when (token = expected) ->
      (Success (advanceInStream stream))
    | _ -> Failure
;;
(* acceptIdent : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un identifiant *)
(* et avance dans l'analyse si c'est le cas *)
let acceptIdent stream = 
  match (peekAtFirstToken stream) with
    | (UL_IDENT _) -> (Success (advanceInStream stream))
    | _ -> Failure
;;
(* acceptIdent : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un entier *)
(* et avance dans l'analyse si c'est le cas *)
let acceptEntier stream = 
  match (peekAtFirstToken stream) with
    | (UL_ENTIER _) -> (Success (advanceInStream stream))
    | _ -> Failure
;;

let acceptName stream = 
  match (peekAtFirstToken stream) with
    | (UL_NAME _) -> (Success (advanceInStream stream))
    | _ -> Failure
;;


(* Définition de la monade  qui est composée de : *)
(* - le type de donnée monadique : parseResult  *)
(* - la fonction : inject qui construit ce type à partir d'une liste de terminaux *)
(* - la fonction : bind (opérateur >>=) qui combine les fonctions d'analyse. *)

(* inject inputStream -> parseResult *)
(* Construit le type de la monade à partir d'une liste de terminaux *)
let inject s = Success s;;

(* bind : 'a m -> ('a -> 'b m) -> 'b m *)
(* bind (opérateur >>=) qui combine les fonctions d'analyse. *)
(* ici on utilise une version spécialisée de bind :
   'b  ->  inputStream
   'a  ->  inputStream
    m  ->  parseResult
*)
(* >>= : parseResult -> (inputStream -> parseResult) -> parseResult *)
let (>>=) result f =
  match result with
    | Success next -> f next
    | Failure -> Failure
;;


(* parseV : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
let rec parseV stream =
  (print_string "V -> ");
  (match (peekAtFirstToken stream) with
    | UL_ACCOUV -> 
      (print_endline "{ X }");
      (inject stream >>=
          accept UL_ACCOUV >>=
          parseX >>=
          accept UL_ACCFER)
    | UL_IDENT (texte) -> 
        (print_endline texte);
        (inject stream >>=
          acceptIdent )
    | UL_ENTIER (entier) -> 
      (print_endline (string_of_int entier));
      (inject stream >>=
        acceptEntier )
    | _ -> Failure)


    and parseX stream = 
    (print_string "X -> ");
    (match (peekAtFirstToken stream) with
      | UL_ACCFER -> 
        (print_string "");
        (inject stream)
      | UL_NAME (_) ->
        (print_endline "F SF");
        (inject stream >>=
            parseF >>=
            parseSF)
      | _ -> Failure)

    and parseF stream =
      (print_string "F -> ");
      (match (peekAtFirstToken stream) with
        | UL_NAME (texte) -> 
          (print_endline (texte ^ " = V"));
          (inject stream >>=
          acceptName >>=
          accept UL_EGAL >>=
          parseV 
            )
        | _ -> Failure)

    and parseSF stream =
      (print_string "SF -> ");
      (match (peekAtFirstToken stream) with
        | UL_ACCFER -> 
          (print_string "");
          (inject stream)
        | UL_POINTVIRGULE -> 
          (print_endline "; F SF");
          (inject stream >>=
            accept UL_POINTVIRGULE >>=
            parseF >>=
            parseSF)
        | _ -> Failure)
;;

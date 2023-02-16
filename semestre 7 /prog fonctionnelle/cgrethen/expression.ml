(* Exercice 3 *)
module type Expression = 
sig
  (* Type pour représenter les expressions *)
  type exp 


 (* eval : exep -> int  *)
(* Evaluer la valeur d’une expression *)
(* Paramètre : exepression qu'on cherche à évaluer  *)
(* Résultat : Un entier représentant l'évaluation de l'expression *)
  val eval : exp -> int
end

(* Exercice 4 *)
(* J'écris ici les types pour pouvoir les utiliser à l'extérieur du module pour éviter d'appeler ExpAvecArbreBinaire*)
type op1 = Moins | Plus | Mult | Div
type exp1=  Binaire of exp1 * op1 * exp1 | Entier of int

module ExpAvecArbreBinaire : Expression with type exp= exp1 =

struct

type exp=  exp1
(* question 2 exercice 4 *)
let eval exp = 
  let rec eval_aux exp = 
    match exp with
    | Entier n -> n
    | Binaire (e1, op, e2) -> 
      let n1 = eval_aux e1 and
          n2 = eval_aux e2 in
      match op with 
      | Mult -> n1 * n2
      | Div -> n1 / n2
      | Moins -> n1 - n2
      | Plus -> n1 + n2
in eval_aux exp

end

 let exp1= Entier 3
 let exp2 = Entier 2
 let exp3= Binaire(exp1,Plus,exp2)
 let exp6= Binaire(exp1,Mult,exp2)
 let exp4= Binaire(exp1,Moins,exp2)
 let exp5= Binaire(exp1,Div,exp2)

let%test  "test eval1" =ExpAvecArbreBinaire.eval(Entier 3)= 3
let%test  "test eval2" =ExpAvecArbreBinaire.eval(exp2)= 2
let%test  "test eval3" =ExpAvecArbreBinaire.eval(exp3)= 5
let%test  "test eval4" =ExpAvecArbreBinaire.eval(exp4)= 1
let%test  "test eval5" =ExpAvecArbreBinaire.eval(exp5)= 1
let%test  "test eval6" =ExpAvecArbreBinaire.eval(exp6)= 6

(* Exercice 5 *)
type op2 = Moins | Plus | Mult | Div
type exp2 = Naire of op2 * exp2 list | Valeur of int


(* bienformee : exp -> bool *)
(* Vérifie qu'un arbre n-aire représente bien une expression n-aire *)
(* c'est-à-dire que les opérateurs d'addition et multiplication ont au moins deux opérandes *)
(* et que les opérateurs de division et soustraction ont exactement deux opérandes.*)
(* Paramètre : l'arbre n-aire dont ont veut vérifier si il correspond à une expression *)
let  bienformee = fun exp ->
  match exp with
  |Valeur _ -> true
  |Naire(op,liste)  when op = Moins || op = Div -> List.length liste = 2
  |Naire(op,liste)  when op = Mult || op = Plus -> List.length liste >= 2
  | _ -> failwith( "Erreur : l'expression n'est pas bonne")


let en1 = Naire (Plus, [ Valeur 3; Valeur 4; Valeur 12 ])
let en2 = Naire (Moins, [ en1; Valeur 5 ])
let en3 = Naire (Mult, [ en1; en2; en1 ])
let en4 = Naire (Div, [ en3; Valeur 2 ])
let en1err = Naire (Plus, [ Valeur 3 ])
let en2err = Naire (Moins, [ en1; Valeur 5; Valeur 4 ])
let en3err = Naire (Mult, [ en1 ])
let en4err = Naire (Div, [ en3; Valeur 2; Valeur 3 ])

let%test _ = bienformee en1
let%test _ = bienformee en2
let%test _ = bienformee en3
let%test _ = bienformee en4
let%test _ = not (bienformee en1err)
let%test _ = not (bienformee en2err)
let%test _ = not (bienformee en3err)
let%test _ = not (bienformee en4err)

(* eval_bienformee : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Précondition : l'expression est bien formée *)
(* Résultat : la valeur de l'expression *)

let  rec  eval_bienformee =  fun exp -> 
  match exp with
  |Valeur n -> n
  |Naire(op,liste) -> 
    (* utilisation d'une  fonction auxiliaire  evalbienformee_aux qui traite les listes de listes qui *)
     let rec evalbienformee_aux liste =
      match liste with
      |[] -> 0
      |[exp] -> eval_bienformee exp
      |t::q -> 
        match op with
        |Mult -> eval_bienformee t * evalbienformee_aux q
        |Div -> eval_bienformee t / evalbienformee_aux q
        |Moins -> eval_bienformee t - evalbienformee_aux q
        |Plus -> eval_bienformee t + evalbienformee_aux q
        
    in evalbienformee_aux liste;;
 

let%test _ = eval_bienformee en1 = 19
let%test _ = eval_bienformee en2 = 14
let%test _ = eval_bienformee en3 = 5054
let%test _ = eval_bienformee en4 = 2527

(* Définition de l'exception Malformee *)
exception Malformee


(* eval : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Résultat : la valeur de l'expression *)
(* Exception  Malformee si le paramètre est mal formé *)
let eval exp =
  if bienformee exp then eval_bienformee exp else raise Malformee;;
let%test _ = eval en1 = 19
let%test _ = eval en2 = 14
let%test _ = eval en3 = 5054
let%test _ = eval en4 = 2527

let%test _ =
  try
    let _ = eval en1err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en2err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en3err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en4err in
    false
  with Malformee -> true
  (* Définition du module ExpAvecArbreNaire avec la bonne fonction EVal : question 1 de l'exercice 4 *)

  module ExpAvecArbreNaire: Expression with type exp= exp2 =
  struct
    type exp = exp2
    let eval = eval
  end





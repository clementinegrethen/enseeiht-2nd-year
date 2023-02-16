(* Exercice 1*)

(* max : int list -> int  *)
(* Paramètre : liste dont on cherche le maximum *)
(* Précondition : la liste n'est pas vide *)
(* Résultat :  l'élément le plus grand de la liste *)
let max = fun l -> 
  let rec aux = fun l max ->
    match l with
    | [] -> max
    | t::q when t>max ->  aux q t
    | _::q -> aux q max
  in aux l (List.hd l);;

  
  (************ tests de max ************)
let%test _ = max [ 1 ] = 1
let%test _ = max [ 1; 2 ] = 2
let%test _ = max [ 2; 1 ] = 2
let%test _ = max [ 1; 2; 3; 4; 3; 2; 1 ] = 4



(* max_max : int list list -> int  *)
(* Paramètre : la liste de listes dont on cherche le maximum *)
(* Précondition : il y a au moins un élement dans une des listes *)
(* Résultat :  l'élément le plus grand de la liste *)

(* j'utilise la fonction précédente avec l'itérateur map *)
let max_max = fun l ->  max (List.map max l);;

let%test _ = max_max [ [ 1 ] ] = 1
let%test _ = max_max [ [ 1 ]; [ 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 2 ]; [ 1; 1; 2; 1; 2 ] ] = 2
let%test _ = max_max [ [ 2 ]; [ 1 ] ] = 2
let%test _ = max_max [ [ 1; 1; 2; 1 ]; [ 1; 2; 2 ] ] = 2


(* Exercice 2*)

(* suivant : int list -> int list *)
(* Calcule le terme suivant dans une suite de Conway *)
(* Paramètre : le terme dont on cherche le suivant *)
(* Précondition : paramètre différent de la liste vide *)
(* Retour : le terme suivant *)

let suivant = fun l ->
  let rec aux liste compteur chiffre_en_cours acc =
    match liste with
    |[]-> acc
    |[x] when x=chiffre_en_cours -> acc @[(compteur+1);x]
    |[x]->acc @[compteur;chiffre_en_cours;1;x]
    |t::q when t=chiffre_en_cours -> aux q (compteur+1) chiffre_en_cours acc
    |t::q -> aux q 1 t (acc @[(compteur);chiffre_en_cours])
  in aux (l)  0 (List.hd l) [];;


let%test _ = suivant [ 1 ] = [ 1; 1 ]
let%test _ = suivant [ 2 ] = [ 1; 2 ]
let%test _ = suivant [ 3 ] = [ 1; 3 ]
let%test _ = suivant [ 1; 1 ] = [ 2; 1 ]
let%test _ = suivant [ 1; 2 ] = [ 1; 1; 1; 2 ]
let%test _ = suivant [ 1; 1; 1; 1; 3; 3; 4 ] = [ 4; 1; 2; 3; 1; 4 ]
let%test _ = suivant [ 1; 3; 3; 4 ] = [ 1; 1; 2; 3; 1; 4 ]
let%test _ = suivant [3;3] = [2;3]


(* suite : int -> int list -> int list list *)
(* Calcule la suite de Conway *)
(* Paramètre taille : le nombre de termes de la suite que l'on veut calculer *)
(* Paramètre depart : le terme de départ de la suite de Conway *)
(* Résultat : la suite de Conway *)
let suite  = fun n depart -> 
  let rec aux compteur acc =
    if compteur = n then acc
    else aux (compteur+1) (acc @ [suivant (List.hd (List.rev acc))])
  in aux 1 [depart];;


let%test _ = suite 1 [ 1 ] = [ [ 1 ] ]
let%test _ = suite 2 [ 1 ] = [ [ 1 ]; [ 1; 1 ] ]
let%test _ = suite 3 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ] ]
let%test _ = suite 4 [ 1 ] = [ [ 1 ]; [ 1; 1 ]; [ 2; 1 ]; [ 1; 2; 1; 1 ] ]
(* Tests de la conjecture *)
(* "Aucun terme de la suite, démarant à 1, ne comporte un chiffre supérieur à 3" *)
(* on utilise la fonction max_max codée en début d'exercice *)
let%test _ = max_max (suite 30 [ 1 ]) <= 3
(* Remarque : Cette méthode de test n'est pas correcte, car nous testons que pour un nombre limité de n, 
   il faudrait une démonstration pour tout n. De plus je ne peux pas tester pour un n grand car dune ne tourne pas (exemple 50 *)
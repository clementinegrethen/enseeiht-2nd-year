open Flux

module type TaylorAlgebra =
  sig
    type t = float Flux.t

    (* Affichage fourni *)
    (* affiche t n affiche les termes de la série t jusqu'à l'ordre n inclus *)
    val affiche : t -> int -> unit

    (* Exercice 1 *)
    val constant : float -> t
    val nats : t
    val var : t

    (* Exercice 2 *)
    val evalue : t -> int -> float -> float

    (* Exercice 3 *)
    val somme : t -> t -> t
    val mult_const : float -> t -> t
    val derive : t -> t
    val integre : t -> t

    (* Exercice 4 *)
    val mult_var : t -> t
    val produit : t -> t -> t

    (* Exercice 5 *)
    val compose : t -> t -> t
    val exp : t -> t

    (* Exercice 6 *)
    val fixpoint : (t -> t) -> t  
  end

module Taylor : TaylorAlgebra =
  struct
    type t = float Flux.t

    let affiche t n =
      let pow = ref 0 in
      begin
        Format.printf "0";
        Flux.print (fun fmt f -> Format.fprintf fmt " + %f * x**%d" f !pow; incr pow) n Format.std_formatter t
      end

    (* Remplacez les assert false par des définitions *)
    let constant c = assert false;;
    
    let nats = assert false;;

    let evalue s n x = assert false;; 

    let somme s1 s2 = assert false;;

    let mult_const k s = assert false;;

    let derive s = assert false;;

    let integre s = assert false;;

    let var = assert false;;

    let mult_var s = assert false;;

    let produit s1 s2 = assert false;;

    let compose f g = assert false;;

    let exp s = assert false;;

    let fixpoint f = assert false;;
  end


(* Test et tracé de la fonction d'Airy, définie récursivement *)
(* La fonction d'Airy est référencée sur Wikipedia            *)
(* Commentez cette partie si elle ne fonctionne pas           *)
(* Commentez l'appel de Dessin.trace_fonction si la librairie *)
(* Graphics n'est pas installée                               *)
(* Le développement limité obtenu par Taylor.affiche          *)
(* peut être copié-collé dans Google et tracé automatiquement *)
(*
let _ =
  let airy_expr y =
    Taylor.(somme (constant 0.35) (integre (somme (constant (-0.26)) (integre (produit var y))))) in
  let rec airy = Flux.(Tick (lazy (uncons (airy_expr airy)))) in
  let airy_fun = Taylor.evalue airy 100 in
  begin
    Taylor.affiche airy 10;
    Dessin.trace_fonction (-10., 0.) airy_fun
  end
 *)

(* Test et tracé de la composition de fonctions               *)
(* exp(1+x*x(x-1)*(x-2))                                      *)
(* Commentez cette partie si elle ne fonctionne pas           *)
(*
let _ =
  let x_moins_1 = Taylor.(somme var (constant (-1.))) in
  let x_moins_2 = Taylor.(somme var (constant (-2.))) in
  let facteur   = Taylor.(produit var (produit x_moins_1 x_moins_2)) in
  let argument  = Taylor.(somme (constant 1.) facteur) in
  let test_exp  = Taylor.(exp argument) in
  let test_fun  = Taylor.evalue test_exp 100 in
  begin
    Taylor.affiche test_exp 10;
    Dessin.trace_fonction (-1., 2.) test_fun
  end
*)

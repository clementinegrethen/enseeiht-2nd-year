(*  Module qui permet la décomposition et la recomposition de données **)
(*  Passage du type t1 vers une liste d'éléments de type t2 (décompose) **)
(*  et inversement (recopose).**)

module type DecomposeRecompose =
sig
  (*  Type de la donnée **)
  type mot
  (*  Type des symboles de l'alphabet de t1 **)
  type symbole

  val decompose : mot -> symbole list
  val recompose : symbole list -> mot
end

module DrString: DecomposeRecompose with type mot = string and type symbole = char =
struct
  type mot = string
  type symbole = char

  let decompose s =
    let rec decompose_chaine i accu =
      if i < 0 then accu
      else decompose_chaine (i-1) (s.[i]::accu)
    in decompose_chaine (String.length s - 1) [];;

    let recompose lc =
      List.fold_right (fun t q -> String.make 1 t ^ q) lc "";;
end

module DRNat  : DecomposeRecompose with type mot= int and type symbole =int =
struct
  type mot=int

  type symbole=int

  let decompose mot=
    let l=ref [] and mot_bis=ref mot in
    while !mot_bis>0 do  
      l:=!l@[( !mot_bis mod 10)];
      mot_bis:=!mot_bis/10 ;
    done;
    List.rev !l;;

  let recompose liste_symbole  = 
    let mot=ref 0 in
    List.iter (fun x -> mot:=!mot*10+x) liste_symbole;
    !mot;;
end

let%test _ = DRNat.decompose 123 = [1;2;3];;
let%test _ = DRNat.recompose [1;2;3] = 123;;

let%test _ = DrString.decompose "abc" = ['a';'b';'c'];;

      
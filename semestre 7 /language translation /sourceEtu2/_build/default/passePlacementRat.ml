(* Module de la passe de placement mémoire *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type

type t1 = Ast.AstType.programme
type t2 = Ast.AstPlacement.programme

(* analyse_placement_instruction : AstTds.instruction -> int -> string -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation du placement en mémoire et tranforme l'instruction
en une instruction de type AstPlacement.instruction *)
(* Erreur si mauvaise utilisation du placement en mémoire *)(* analyser : AstType.programme -> AstPlacement.programme *)
let rec analyse_placement_instr i depl reg =
  match i with
    | AstType.Declaration (info,e) ->
      begin
        match info_ast_to_info info with
          |InfoVar(_,t,_,_) -> modifier_adresse_variable depl reg info;
            (AstPlacement.Declaration (info,e), getTaille t)
          | _ -> failwith "cas erroné"
      end
    | AstType.TantQue (c,b) ->
      let nb = analyse_placement_bloc b depl reg in
      (AstPlacement.TantQue (c,nb), 0)
    | AstType.Retour (e,ia) ->
      begin
        match info_ast_to_info ia with
          | InfoFun(_,t,ep) -> (AstPlacement.Retour(e, getTaille t, List.fold_right (+) (List.map getTaille ep) 0), 0)
          | _ -> raise MauvaisType
      end
    | AstType.Affectation (info,e2) -> (AstPlacement.Affectation (info,e2), 0)
    | AstType.Conditionnelle (e,b1,b2) ->
      let nb1 = analyse_placement_bloc b1 depl reg in
      let nb2 = analyse_placement_bloc b2 depl reg in
      (AstPlacement.Conditionnelle (e,nb1,nb2), 0)
    |AstType.Conditionnelle_sans_else (e,b) ->
      let nb = analyse_placement_bloc b depl reg in
      (AstPlacement.Conditionnelle_sans_else (e,nb), 0)
    | AffichageInt e -> (AstPlacement.AffichageInt e, 0)
    | AffichageRat e -> (AstPlacement.AffichageRat e, 0)
    | AffichageBool e -> (AstPlacement.AffichageBool e, 0)
    | AstType.Empty -> (AstPlacement.Empty, 0)
    | AstType.Loop_etiquette(n,b) ->
      let nb = analyse_placement_bloc b depl reg in
      (AstPlacement.Loop_etiquette(n,nb), 0)
    | AstType.Break_etiquette(n) -> (AstPlacement.Break_etiquette(n), 0)
    | AstType.Continue_etiquette(n) -> (AstPlacement.Continue_etiquette(n), 0)

  
(* analyse_placement_bloc : AstType.bloc -> AstPlacement.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation du placement en mémoire et tranforme le bloc
en un bloc de type AstPlacement.bloc *)
(* Erreur si mauvaise utilisation du placement en mémoire *)
and analyse_placement_bloc li depl reg =
      match li with
      | [] -> ([],0)
      | i::li -> 
        let (ni,ti) = analyse_placement_instr i depl reg in
        let (ntl,tli) = analyse_placement_bloc li (depl+ti) reg in
        (ni::ntl, ti+tli)

(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation du placement en mémoire et tranforme la fonction
en une fonction de type AstPlacement.fonction *)
(* Erreur si mauvaise utilisation du placement en mémoire *)
let analyse_placement_fonction (AstType.Fonction(ia,lia,nli)) =
  let modif_info param valeur =
    match info_ast_to_info param with
      |InfoVar(_,t,_,_) ->
        let nvaleur = valeur - getTaille t in
          modifier_adresse_variable nvaleur "LB" param;
          nvaleur
          | _ -> raise MauvaisType
  in
  let _ = List.fold_right modif_info lia 0 in
  let nb = analyse_placement_bloc nli 3 "LB" in
  AstPlacement.Fonction(ia,lia,nb)

(* analyser : AstType.programme -> AstPlacement.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation du placement en mémoire et tranforme le programme
en un programme de type AstPlacement.programme *)
(* Erreur si mauvaise utilisation du placement en mémoire *)
let analyser (AstType.Programme (fonctions, bloc)) =
  let nf = List.map analyse_placement_fonction fonctions in
  let nb = analyse_placement_bloc bloc 0 "SB" in
  AstPlacement.Programme (nf,nb)

  
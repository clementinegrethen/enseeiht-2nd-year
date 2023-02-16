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
(* Paramètre dep : le déplacement à utiliser *)
(* Paramètre reg : le registre à utiliser *)
(* Vérifie le placement mémoire des instructions et tranforme l'instruction
en une AstPlacement.instructions *)
(* Renvoie l'instruction et le déplacement utilisé *)
(* Erreur si mauvais placement en mémoire *)
let rec analyse_placement_instruction i dep reg =
  match i with
    | AstType.TantQue (cond,bloc) ->
      let nbloc = analyse_placement_bloc bloc dep reg in
      (AstPlacement.TantQue (cond,nbloc), 0)
    | AstType.Retour (e,ia) ->
      begin
        match info_ast_to_info ia with
          | InfoFun(_,t,ep) -> (AstPlacement.Retour(e, getTaille t, List.fold_right (+) (List.map getTaille ep) 0), 0)
          | _ -> raise MauvaisType
      end
      | AstType.Declaration (inf,e) ->
        begin
          match info_ast_to_info inf with
            |InfoVar(_,t,_,_) -> modifier_adresse_variable dep reg inf;
              (AstPlacement.Declaration (inf,e), getTaille t)
            | _ -> failwith "Mauvais type"
        end
    | AstType.Affectation (inf,e) -> (AstPlacement.Affectation (inf,e), 0)
    | AstType.Conditionnelle (cond,bloc1,bloc2) ->
      let nbloc1 = analyse_placement_bloc bloc1 dep reg in
      let nbloc2 = analyse_placement_bloc bloc2 dep reg in
      (AstPlacement.Conditionnelle (cond,nbloc1,nbloc2), 0)
    |AstType.Conditionnelle_sans_else (cond,bloc) ->
      let nbloc = analyse_placement_bloc bloc dep reg in
      (AstPlacement.Conditionnelle_sans_else (cond,nbloc), 0)
    | AffichageInt e -> (AstPlacement.AffichageInt e, 0)
    | AffichageRat e -> (AstPlacement.AffichageRat e, 0)
    | AffichageBool e -> (AstPlacement.AffichageBool e, 0)
    | AstType.Loop_etiquette(id,bloc) ->
      let nbloc = analyse_placement_bloc bloc dep reg in
      (AstPlacement.Loop_etiquette(id,nbloc), 0)
    |AstType.Loop(bloc) -> let nbloc = analyse_placement_bloc bloc dep reg in
      (AstPlacement.Loop(nbloc), 0)
    | AstType.Break_etiquette(id) -> (AstPlacement.Break_etiquette(id), 0)
    | AstType.Break -> (AstPlacement.Break, 0)
    | AstType.Continue_etiquette(id) -> (AstPlacement.Continue_etiquette(id), 0)
    | AstType.Continue -> (AstPlacement.Continue, 0)
    | AstType.Empty -> (AstPlacement.Empty, 0)
  
(* analyse_placement_bloc : AstType.bloc -> AstPlacement.bloc *)
(* Paramètre listeInstr : liste d'instructions à analyser *)
(* Vérifie le placement mémoire des blocs et les transforme en AstPlacement.bloc *)
(* Erreur si mauvais placement en mémoire *)
and analyse_placement_bloc listeInstr dep reg =
      match listeInstr with
      | [] -> ([],0)
      | instr::listeInstr -> 
        let (ninstr, depinstr) = analyse_placement_instruction instr dep reg in
        let (nli,depli) = analyse_placement_bloc listeInstr (dep+depinstr) reg in
        (ninstr::nli, depinstr+depli)

(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation du placement en mémoire et tranforme la fonction
en une fonction de type AstPlacement.fonction *)
(* Erreur si mauvaise utilisation du placement en mémoire *)
let analyse_placement_fonction (AstType.Fonction(id,lparam,nibloc)) =
  let analyse_intermediaire info valeur =
    match info_ast_to_info info with
      |InfoVar(_,t,_,_) ->
        let nvaleur = valeur - getTaille t in
          modifier_adresse_variable nvaleur "LB" info;
          nvaleur
          | _ -> raise MauvaisType
  in
  let _ = List.fold_right analyse_intermediaire lparam 0 in
  let nbloc = analyse_placement_bloc nibloc 3 "LB" in
  AstPlacement.Fonction(id,lparam,nbloc)

(* analyser : AstType.programme -> AstPlacement.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation du placement en mémoire et tranforme le programme
en un programme de type AstPlacement.programme *)
(* Erreur si mauvaise utilisation du placement en mémoire *)
let analyser (AstType.Programme (fonctions, bloc)) =
  let nf = List.map analyse_placement_fonction fonctions in
  let nb = analyse_placement_bloc bloc 0 "SB" in
  AstPlacement.Programme (nf,nb)

  
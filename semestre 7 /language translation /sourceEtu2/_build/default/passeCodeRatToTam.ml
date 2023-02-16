(*(* Module de la passe de génération de code *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type
open AstPlacement
open AstType
open Tam
open Code

type t1 = Ast.AstPlacement.programme
type t2 = string

(* analyse_tds_expression : AstTds.expression -> AstType.expression *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'expression
en une expression de type AstType.expression *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_code_expr e =
  match e with
    |AppelFonction(info,lc) ->
      begin
        match (info_ast_to_info info) with
        |InfoFun(name,_,_) -> String.concat "" (List.map analyse_code_expr lc)^ call "ST" name
        |_ -> failwith "InternalError"
    end
    |Ident info ->
      begin
      match (info_ast_to_info info) with
        |InfoVar(_, t, depl, reg) -> load (getTaille t) depl reg
        |InfoConst (_,i) -> loadl_int i
        |_ -> failwith "InternalError"
      end
    |Booleen b -> if b then loadl_int 1
                else loadl_int 0
    |Entier i -> loadl_int i
    |Unaire(op,e1) ->
      begin
      analyse_code_expr e1 ^
      match op with
        |Numerateur -> pop 0 1
        |Denominateur -> pop 1 1
      end
    |Binaire(op, e1, e2) ->
      let c1 = analyse_code_expr e1 in
      let c2 = analyse_code_expr e2 in
      begin
        match op with
          | Fraction -> c1^c2^(call "ST" "norm")
          | PlusInt -> c1^c2^(subr "IAdd")
          | PlusRat -> c1^c2^(call "ST" "RAdd")
          | MultInt -> c1^c2^(subr "IMul")
          | MultRat -> c1^c2^(call "ST" "RMUl")
          | EquInt  -> c1^c2^(subr "IEq")
          | EquBool -> c1^c2^(subr "IEq")
          | Inf -> c1^c2^(subr "ILss")
      end
  
      
let rec analyse_code_instr i =
  match i with
  | AstPlacement.Declaration (info,e) ->
    begin
      match info_ast_to_info info with
        | InfoVar(_,t,depl,reg) ->
          push (getTaille t)
          ^ analyse_code_expr e
          ^ store (getTaille t) depl reg
        | _ -> raise MauvaisType
    end
  | Affectation(info,e) ->
    begin
      match info_ast_to_info info with
        | InfoVar(_,t,depl,reg) ->
          analyse_code_expr e
          ^ store (getTaille t) depl reg
        | _ -> raise MauvaisType
    end
  | AffichageInt e ->
    analyse_code_expr e ^ subr "IOut"
  | AffichageBool e ->
    analyse_code_expr e ^ subr "BOut"
  | AffichageRat e ->
    analyse_code_expr e ^ call "ST" "ROut"
  | Conditionnelle(e,b1,b2) ->
    let sinon = getEtiquette() in
    let finSi = getEtiquette() in
    analyse_code_expr e
    ^ jumpif 0 sinon
    ^ analyse_code_bloc b1
    ^ jump finSi
    ^ label sinon
    ^ analyse_code_bloc b2
    ^ label finSi
  | TantQue (e,b) ->
    let tantQue = getEtiquette() in
    let finTantQue = getEtiquette() in
    label tantQue
    ^ analyse_code_expr e
    ^ jumpif 0 finTantQue
    ^ analyse_code_bloc b
    ^ jump tantQue
    ^ label finTantQue
  | Retour(e,tr,tp) ->
              (analyse_code_expr e) ^ return tr tp

  | Empty -> ""

and analyse_code_bloc (li,taille) =
  String.concat "" (List.map analyse_code_instr li) ^ (pop 0 taille)

let analyse_code_fonction (AstPlacement.Fonction(ia,_,nli)) =
  match info_ast_to_info ia with
  | InfoFun(name,_,_) ->
    name ^ "\n" ^ analyse_code_bloc nli ^ halt
  | _ -> raise MauvaisType


(* analyser : AstPlacement.programme -> string *)
(* Paramètre : le programme à analyser *)
(* Tranforme le programme en une suite d'instruction sous forme d'une string *)
(* Erreur si mauvaise utilisation de la génération de code *)
let analyser (AstPlacement.Programme(fonctions, bloc)) =
  getEntete()
  ^ String.concat "" (List.map analyse_code_fonction fonctions)
  ^ label "main"
  ^ analyse_code_bloc bloc
  ^ halt
*)
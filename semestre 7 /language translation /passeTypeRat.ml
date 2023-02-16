
  (*

let rec analyse_type_instruction tr i =
  match i with 
  |AstTds.Declaration (t,info,e) -> let (ne,te)=analyse_type_expressionession e in
  if est_compatible te t then 
    (modifier_type_variable t info;
   AstType.Declaration(info,ne))
else raise (TypeInattendu(te,t))

|AstTds.Affectation (info,e)->
  let (ne,t)=analyse_type_expressionession e in
    if (est_compatible (getType info) t) then  
      AstType.Affectation(info,ne)
  else raise (TypeInattendu((getType info),t))

  |AstTds.Conditionnelle(e,b1,b2)->
    let ce,ct = analyse_type_expressionession e in
    let te = analyse_type_bloc b1 tr in
    let ee = analyse_type_bloc b2 tr in
    begin match Type.est_compatible ct Bool with
          | true -> Conditionnelle(ce,te,ee)
          | false -> raise (TypeInattendu (ct,Bool))
    end

  |AstTds.Affichage(e)-> let (x,t)=analyse_type_expressionession e in
   begin match t with
    |Int-> AffichageInt(x)
    |Rat->AffichageRat(x)
    |Bool -> AffichageBool(x)
    |_ -> assert false
  end
  |AstTds.TantQue(e,b)-> 
    let (ne,t) = analyse_type_expressionession e in
    if est_compatible t Bool then AstType.TantQue(ne,analyse_type_bloc b tr)
    else 
      raise (TypeInattendu(t,Bool))

  |AstTds.Retour(e,ia)-> 
    let (ne,t) = analyse_type_expressionession e in
    if est_compatible t (getType ia) then AstType.Retour(ne,ia)
    else 
      raise (TypeInattendu(t, (getType ia)))
  |AstTds.Empty->AstType.Empty
 
  and analyse_type_bloc li tr =
   let nli= List.(map (analyse_type_instruction tr) li ) in nli

let analyse_type_fonction (AstTds.Fonction(t,ia,lp,li))  = 
  let tp,lia = List.split lp in 
  modifier_type_fonction t tp ia ;
  let _ = List.map2 modifier_type_variable tp lia in 
  let nli = analyse_type_bloc li t in AstType.Fonction(ia,lia,nli)

   let analyser (AstTds.Programme (fonctions,prog)) =
    let nf = List.map analyse_type_fonction fonctions in 
    let nb = analyse_type_bloc prog Undefined in
   AstType.Programme (nf,nb)*)


(* Module de la passe de gestion des types *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type

type t1 = Ast.AstTds.programme
type t2 = Ast.AstType.programme

(* analyse_type_affectable : AstTds.affectable -> AstType.affectable * type *)
(* Paramètre aff : l'affectable à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'affectable*)
(* CF TD pointeurs*)
let rec analyse_type_affectable aff =
  match aff with
  | AstTds.Ident i -> begin 
    match info_ast_to_info i with 
        | InfoVar(_,t,_,_) -> (AstType.Ident i, t)
        | InfoConst _ ->(AstType.Ident i, Int)
        | _ -> raise(ErreurInterne)
        end
| AstTds.Valeur(aff) -> begin
    match analyse_type_affectable aff with 
        | (naff,Pointeur t) -> (AstType.Valeur naff,t)
        | _ -> raise(NotAPointer)
        end


(* analyse_tds_expression : AstTds.expression -> AstType.expression *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'expression
en une expression de type AstType.expression *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_type_expression e = 
  match e with
  |AstTds.Booleen(b)->(AstType.Booleen(b) , Bool)
  |AstTds.Entier(e) -> (AstType.Entier(e) , Int)
  | AstTds.Unaire(op, e) -> 
    let (ne, te) = analyse_type_expression e in
    if (not (est_compatible te Rat)) then 
      raise (TypeInattendu(te, Rat))
    else 
      begin
        match op with
        | Denominateur -> (AstType.Unaire(AstType.Denominateur, ne), Int)
        | Numerateur -> (AstType.Unaire(AstType.Numerateur, ne), Int)
      end 

      |AstTds.Binaire(b,e1,e2)->
        let (ne1,t1) = analyse_type_expression e1 in
        let (ne2,t2) = analyse_type_expression e2 in      
        begin match b,t1,t2 with
          (* change l'opérateur binaire pour prendre en compte le type des expressions *)
            |Inf,Int,Int -> Binaire(Inf,ne1,ne2), Bool
            |Fraction,Int,Int -> Binaire(Fraction,ne1,ne2), Rat
            |Plus,Int,Int -> Binaire(PlusInt,ne1,ne2), Int
            |Plus,Rat,Rat -> Binaire(PlusRat,ne1,ne2), Rat
            |Mult,Rat,Rat -> Binaire(MultRat,ne1,ne2), Rat
            |Mult,Int,Int -> Binaire(MultInt,ne1,ne2), Int
            |Equ,Int,Int -> Binaire(EquInt,ne1,ne2), Bool
            |Equ,Bool,Bool -> Binaire(EquBool,ne1,ne2), Bool
            |_ -> raise (TypeBinaireInattendu (b,t1, t2))
        end
    | AstTds.AppelFonction(il, el) -> 
      begin
        let l = List.map analyse_type_expression el in
        let lt = List.map snd l in
        let rec rechercheFonction il = 
          match il with 
          | i::q -> 
            begin
              match info_ast_to_info i with 
              | InfoFun(_,typeRetour,typeParam) -> 
                if (est_compatible_list typeParam lt) then AstType.AppelFonction(i, List.map fst l), typeRetour
                else rechercheFonction q
              | _ -> raise MauvaisType
            end
          | [] -> raise (TypesParametresInattendus (lt,[]))
        in rechercheFonction il
      end

    (* gestion des pointeurs*)
    | AstTds.Affectable a -> let (na,t)= analyse_type_affectable a in (AstType.Affectable na, t)
    

    | AstTds.Null -> (Null,Pointeur Undefined)
    | AstTds.New t -> New t, Pointeur t
    | AstTds.Adresse info -> begin 
        match info_ast_to_info info with
            | InfoVar(_,t,_,_) -> (Adresse info, Pointeur t)
            | _ -> raise(ErreurInterne)
        end
    (* gestion de la conditionnelle ternaire*)
    | AstTds.Conditionnelle_Ternaire(condition,expr1,expr2) -> 
      let (nexpr1, texpr1) = analyse_type_expression expr1 in
      let (nexpr2, texpr2) = analyse_type_expression expr2 in
      let (ncondition, tcondition) = analyse_type_expression condition in
      if (est_compatible tcondition Bool) then 
        if (est_compatible texpr1 texpr2) 
          then (AstType.Conditionnelle_Ternaire(ncondition, nexpr1, nexpr2), texpr1)
        else 
          raise (TypeInattendu(texpr1, texpr2))
      else 
        raise (TypeInattendu(tcondition, Bool))
   

(* analyse_type_instruction : AstTds.instruction -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'instruction
en une instruction de type AstType.instruction *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_type_instruction i =
  match i with 
  |AstTds.Declaration (t,info,e) -> let (ne,te)=analyse_type_expression e in
        if est_compatible te t then 
          (modifier_type_variable t info;
          AstType.Declaration(info,ne))
       else raise (TypeInattendu(te,t))
    
  
  | AstTds.Affectation(aff, e) ->
      let (naff, taff) = analyse_type_affectable aff in
      let (ne, texp) = analyse_type_expression e in
      if est_compatible texp taff then Affectation(naff, ne)
      else raise (TypeInattendu(texp, taff))

  |AstTds.Affichage(e)-> let (x,t)=analyse_type_expression e in
    begin match t with
      |Int-> AffichageInt(x)
      |Rat->AffichageRat(x)
      |Bool -> AffichageBool(x)
      |_ -> assert false
    end

  | AstTds.Conditionnelle(e,b1,b2) ->
    let (ne,te) = analyse_type_expression e in
    begin match (est_compatible te Bool) with
      | true -> AstType.Conditionnelle(ne, analyse_type_bloc b1, analyse_type_bloc b2)
      | false -> raise (TypeInattendu(te,Bool))
    end
(* traitement du conditionnel sans Else*)
  | AstTds.Conditionnelle_sans_else (e,b)-> 
    let (ne,te) = analyse_type_expression e in
    begin match (est_compatible te Bool) with
      | true -> AstType.Conditionnelle_sans_else(ne, analyse_type_bloc b)
      | false -> raise (TypeInattendu(te,Bool))
    end

  | AstTds.TantQue(e,b) ->
    let (ne,te) = analyse_type_expression e in
      if (est_compatible te Bool)
      then AstType.TantQue(ne, analyse_type_bloc b)
      else raise (TypeInattendu(te,Bool))

  | AstTds.Retour(e,i) -> let (ne, te) = analyse_type_expression e in
  begin
    match info_ast_to_info i with
      |InfoFun(_,t,_) -> if (est_compatible t te) then AstType.Retour(ne,i)
      else raise (TypeInattendu(te,t))
      | _ -> raise MauvaisType
  end
  
  | AstTds.Empty -> AstType.Empty
(* traitement des Loop à la Rust*)
  | AstTds.Loop_etiquette(info,b) -> 
    AstType.Loop_etiquette(info, analyse_type_bloc b)
  |AstTds.Loop (b) -> AstType.Loop (analyse_type_bloc b)
  | AstTds.Break_etiquette(info) -> AstType.Break_etiquette(info)
  | AstTds.Break -> AstType.Break
  | AstTds.Continue_etiquette(info) -> AstType.Continue_etiquette(info)
  | AstTds.Continue -> AstType.Continue
 


(* analyse_type_bloc : AstTds.bloc -> AstType.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le bloc en un bloc de type AstType.bloc *)
(* Erreur si mauvaise utilisation des types *)
and analyse_type_bloc li = List.map analyse_type_instruction li


(* analyse_type_fonction : AstTds.fonction -> AstType.fonction *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstTds.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_type_fonction (AstTds.Fonction(t,ia,lp,li)) = 
  let types_params, noms_params = List.split lp in 
  let _ = modifier_type_fonction t types_params ia in
  let _ = List.iter2 (fun tp np -> modifier_type_variable tp np) types_params noms_params in 
  AstType.Fonction(ia, noms_params, analyse_type_bloc li) 

  
(* analyser : AstTds.programme -> AstType.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme*)

let analyser (AstTds.Programme (fonctions,prog)) =
  let nf = List.map analyse_type_fonction fonctions in
  let nb = analyse_type_bloc prog in
  AstType.Programme (nf,nb)



   

    
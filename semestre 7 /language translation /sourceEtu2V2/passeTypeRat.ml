
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
  | AstTds.Ident info -> begin 
    match info_ast_to_info info with 
        | InfoVar(_,t,_,_) -> (AstType.Ident info, t)
        | InfoConst _ ->(AstType.Ident info, Int)
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
(* A changer!!*)
    | AstTds.AppelFonction(infol, el) -> 
      begin
        let l = List.map analyse_type_expression el in
        let lt = List.map snd l in
        let rec chercherFonction infol = 
          match infol with 
          | [] -> raise (TypesParametresInattendus (lt,[]))
          | info::q -> 
            begin
              match info_ast_to_info info with 
              | InfoFun(_,tr,tp) -> 
                if (est_compatible_list tp lt) then AstType.AppelFonction(info, List.map fst l), tr
                else chercherFonction q
              | _ -> raise MauvaisType
            end
        in chercherFonction infol
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
    (* A changer!**)
    | AstTds.Conditionnelle_Ternaire(cond,e1,e2) -> 
      let (ncond, tcond) = analyse_type_expression cond in
      let (ne1, te1) = analyse_type_expression e1 in
      let (ne2, te2) = analyse_type_expression e2 in
      if (est_compatible tcond Bool) then 
        if (est_compatible te1 te2) then (AstType.Conditionnelle_Ternaire(ncond, ne1, ne2), te1)
        else raise (TypeInattendu(te2, te1))
      else raise (TypeInattendu(tcond, Bool))
   

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
  | AstTds.SwitchCase (e,l) ->
    let (ne,te) = analyse_type_expression e in
    (* split3 qui split l en 3 *)
    let lc,lli,lb = (List.fold_right(fun(a,b,c) qt -> let (qt1,qt2,qt3) = qt in (a::qt1,b::qt2,c::qt3)) l ([],[],[])) in
    (* on analyse la liste des cas *)
    let nlca = List.map analyse_type_expression lc in
    (* on analyse la liste des booleens (break ou pas break) *)
    let nlba = List.map analyse_type_expression lb in
    let nlb,nltb = List.split nlba in
    let nlc,nltc = List.split nlca in
    (* on verifie que tout les types des cases sont les memes *)
    List.iter (fun x -> if (not (est_compatible te x) && x!=Def)  then raise (TypeInattendu(te,x))) nltc;
    (* on verifie que tout les types des booleens du break sont des booleens *)
    List.iter (fun x -> if not (est_compatible Bool x) then raise (TypeInattendu(Bool,x))) nltb;
    (* on analyse les blocs *)
    let nlli = List.map analyse_type_bloc lli in
    (* on recombine le tout *)
    let nl = begin match (nlc,nlli,nlb)  with
      | [],[],[]-> []
      | [],_,_ | _,[],_ | _,_,[] -> failwith "les listes ne sont pas de même taille"
      | (a::r1,b::r2,c::r3) -> let l = merge3(r1,r2,r3) in (a,b,c)::l
     end in
        AstType.SwitchCase (ne,nl)
 


(* analyse_type_bloc : AstTds.bloc -> AstType.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le bloc en un bloc de type AstType.bloc *)
(* Erreur si mauvaise utilisation des types *)
and analyse_type_bloc li = List.map analyse_type_instruction li

(* A MODIFIER*)
(* analyse_type_fonction : AstTds.fonction -> AstType.fonction
Paramee : fonction à analyser *)
(* analyse du type dans une fonction, on modifie dans la tds le type de retour et les types des paramètres *)
let analyse_type_fonction (AstTds.Fonction(t,ia,lp,li)) = 
  let tp,lia = List.split lp in 
  modifier_type_fonction t tp ia ;
  let _ = List.map2 modifier_type_variable tp lia in 
  AstType.Fonction(ia,lia,analyse_type_bloc li) 
  
(* analyser : AstTds.programme -> AstType.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme*)

let analyser (AstTds.Programme (fonctions,prog)) =
  let nf = List.map analyse_type_fonction fonctions in
  let nb = analyse_type_bloc prog in
  AstType.Programme (nf,nb)



   

    
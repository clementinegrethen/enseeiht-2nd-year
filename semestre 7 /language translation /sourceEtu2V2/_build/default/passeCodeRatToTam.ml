(* Module de la passe de creation du code *)


  open Tds
  open Exceptions
  open Ast
  open AstPlacement
  open Type
  open Code
  open Tam 

  type t1 = AstPlacement.programme
  type t2 = string

let n = "\n"
let rec list_concat l = 
  match l with 
  | [] -> ""
  | t::q -> (t^"\n")^(list_concat q)

(* analyse_code_affectable : AstType.affectable -> String * (int * int * string ) *)
(* Paramètre a : affectable dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM relatif à un affectable *)
let rec analyse_code_affectable a =
  match a with
  | AstType.Valeur _ -> failwith "" (*A REFAIRRREEREAOFIAEOIFNAEPOFJ?*)
  | AstType.Ident info ->
    begin
      match info_ast_to_info info with
      | InfoVar(_, t, dep, reg) -> store (getTaille t) dep reg
      | _ -> failwith "Probleme analyse code affectable" 
    end

 

(* analyse_code_expression : AstType.expression -> String *)
(* Paramètre e : expression dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM relatif à cette expression *)
let rec analyse_code_expression e = 
  match e with
    |AstType.AppelFonction (infoast, el) -> 
         begin match info_ast_to_info infoast with
            | InfoFun(str,_,_) -> 
                (List.fold_left (fun code e -> code ^ n ^ (analyse_code_expression e)) "" el)
                 ^ "CALL (ST) " ^ str
            | _ -> assert false
         end
    |AstType.Binaire (b,e1,e2) ->
        (analyse_code_expression e1) ^ n ^ (analyse_code_expression e2) ^ n ^
        begin match b with
            (* appel des opérations suivant le type des expressions *)
            |Inf ->  "SUBR ILss" 
            |PlusInt ->   "SUBR IAdd" 
            |PlusRat -> "CALL (ST) radd"
            |MultInt -> "SUBR IMul"  
            |MultRat -> "CALL (ST) rmul"
            |EquBool -> "SUBR IEq" 
            |EquInt -> "SUBR IEq"
            |Fraction ->  "CALL (ST) norm" 
        end
    |AstType.Unaire (Numerateur,e1) -> analyse_code_expression e1 
    |AstType.Unaire (Denominateur,e1) -> analyse_code_expression e1
    |AstType.Entier (i) -> Printf.sprintf "LOADL %d" i
    |AstType.Booleen (b) -> if b then "LOADL 1 " else "LOADL 0"
    (* créer un emplacement alloué en mémoire pour un pointeur avec MAlloc *)
    | AstType.New t -> (loadl_int (getTaille t))^subr "MAlloc"
    |AstType.Null -> Printf.sprintf "LOADL %d \nSUBR MAlloc \n" 1
    |AstType.Adresse ia -> 
      begin match info_ast_to_info ia with 
        |InfoVar(_,_,d,r) -> Printf.sprintf "LOADA %d [%s] \n" d r
        | _ -> assert false
      end 
      | AstType.Affectable a -> analyse_code_affectable a


      |AstType.Conditionnelle_Ternaire(e1,e2,e3) ->
        let sinon = getEtiquette() in
        let finSi = getEtiquette() in
        analyse_code_expression e1
        ^ jumpif 0 sinon
        ^ analyse_code_expression e2
        ^ jump finSi
        ^ label sinon
        ^ analyse_code_expression e3
        ^ label finSi

(* analyse_code_instruction : AstType.instruction -> String * int *)
(* Paramètre i : instruction dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM relatif à cette instruction et la taille des variables 
qui ont été déclaré localement *)
let rec analyse_code_instruction i =
  match i with
  | AstPlacement.Declaration (info, e) ->
    begin
      match info_ast_to_info info with 
        | InfoVar (_, t, dep, reg) -> 
          push (getTaille t)
          ^ analyse_code_expression e
         ^ store (getTaille t) dep reg
        | _ -> failwith "analyse_code_instruction : Declaration"
    end
  | AstPlacement.Affectation (a, e) ->
    let na = analyse_code_affectable a in
    let ne = analyse_code_expression e in 
    ne^na


  | AstPlacement.Conditionnelle (c, b1, b2) -> 
    let nc = analyse_code_expression c in
    let iff = getEtiquette () in
    let fi = getEtiquette () in
    nc
    ^ jumpif 0 iff
    ^ analyse_code_bloc b1
    ^ jump fi
    ^ label iff
    ^ analyse_code_bloc b2
    ^ label fi
  | AstPlacement.Conditionnelle_sans_else(c,b) ->
    let nc = analyse_code_expression c in
    let iffc = getEtiquette () in
    let fic = getEtiquette () in
    nc
    ^jumpif 0 iffc
    ^ analyse_code_bloc b
    ^ label iffc
    ^ label fic
  
  | AstPlacement.TantQue (c, b) -> 
    let nc = analyse_code_expression c in
    let wh = getEtiquette() in
    let endwhile = getEtiquette() in
    let nb = analyse_code_bloc b in
    label wh
    ^ nc
    ^ jumpif 0 endwhile
    ^ nb
    ^ jump wh
    ^ label endwhile
  | AstPlacement.AffichageInt e ->
    analyse_code_expression e
    ^ subr (label "IOUT")
  | AstPlacement.AffichageRat e ->
    analyse_code_expression e
    ^ call "ST" "ROUT"
  | AstPlacement.AffichageBool e ->
    analyse_code_expression e
    ^ subr (label "BOUT")
  | AstPlacement.Retour (e, tr, tp) ->
    analyse_code_expression e
    ^ return tr tp
  | AstPlacement.Empty -> ""
  

(* analyse_code_instruction : AstType.bloc -> String *)
(* Paramètre i : instruction dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM relatif à cette instruction *)
and analyse_code_bloc li =
let (l,n) = li in
let nli = List.map analyse_code_instruction l in
(list_concat nli)^(pop 0 n)

(* analyse d'une  fonction avec un retour qui renvoie les données en fonction de la taille
du paramètre de retour de la fonction, le HALT permet de ne pas rester bloquer dans
une focntion *)

(* analyse_code_fonction : AstPlacement.fonction -> String *)
(* Paramètre fonction : fonction dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM qui traduit cette fonction *)
let analyse_code_fonction (Fonction(iaf,_,b))  = 
 match info_ast_to_info iaf with
 |InfoFun(nom,t,lt) -> 
              let tailleparam = List.fold_left (fun taille t -> taille + (Type.getTaille t)) 0 lt in
              let tailleretour = Type.getTaille t in
              nom ^ n ^ (analyse_code_bloc b) 
                ^ n ^ Printf.sprintf "RETURN (%d) %d \n" tailleretour tailleparam 
                ^n^ "HALT \n"

 |_ -> assert false

(* analyse d'un programme, d'entete JUMP MAIN, et avec HALT pour arreter le programme à la fin *)

(* analyser : AstPlacement.programme -> String *)
(* Paramètre programme : programme à traduire *)
(* Renvoie le code TAM qui traduit le programme passé en paramètre *)
let analyser (Programme (fonctions,prog)) =
 Code.getEntete () ^n^n^
 List.fold_left (fun code e -> code ^ n ^ (analyse_code_fonction e)) "" fonctions
 ^n^
 "main"^n^
 analyse_code_bloc prog ^n^
 "HALT \n"


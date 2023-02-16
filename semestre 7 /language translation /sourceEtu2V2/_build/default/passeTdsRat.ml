(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Ast
open Exceptions

type t1 = Ast.AstSyntax.programme
type t2 = Ast.AstTds.programme



(*Gestion des pointeurs*)
(* analyse_tds_affecatble :  tds -> bool -> AstSyntax.affectable -> AstTds.affectable
    Paramètre tds : la table des symboles courante
    Paramètre modif : true si l'affectable est utilisé dans une affectation, false sinon
    Paramètre a : l'affectable à analyser
    Vérifie la bonne utilisation des identifiants et tranforme l'affectable
    en une affectable de type AstTds.affectable
    Erreur si mauvaise utilisation des identifiants
   *)

(* Fonction prise du td sur les pointeurs*)
let rec analyse_tds_affectable tds modif a =
  match a with 
    | AstSyntax.Ident(n) -> begin
      match chercherGlobalement tds n with 
        | None -> raise (IdentifiantNonDeclare n)
        | Some info -> begin
          match info_ast_to_info info with 
            | InfoFun (_,_,_) -> raise(MauvaiseUtilisationIdentifiant n)
            | InfoVar (_,_,_,_) -> AstTds.Ident(info)
            | InfoConst (_,_) -> 
                if modif then raise(MauvaiseUtilisationIdentifiant n)
                else AstTds.Ident(info)
            |_ -> raise(MauvaiseUtilisationIdentifiant n)
           
            end 
    end 
    | AstSyntax.Valeur(v) -> AstTds.Valeur(analyse_tds_affectable tds modif v)


(* analyse_tds_expression : tds -> AstSyntax.expression -> AstTds.expression *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)


let rec analyse_tds_expression tds e =
   match e with
(* Appel de fonction, on traite la surcharge comme au partiel*)
  | AstSyntax.AppelFonction (nom, list_expression) ->
    begin
      match (chercherGlobalementFonctions tds nom) with
      (*on peut donc avoir plusieurs fonction de même nom dans la TDS : plusieurs infoFun, d'où la création de ChercherGlobalementFonction*)
      | [] -> raise (IdentifiantNonDeclare nom)
      | l -> 
        let l = List.map (fun info -> 
                                begin
                                  match info_ast_to_info info with
                                  | InfoFun(_,_,_) -> info 
                                  | _ -> raise (MauvaiseUtilisationIdentifiant nom)
                                end
                                ) l in
        (* l sera donc une liste d'infoFun : correspondantes à l'identifiant nom *)
        AstTds.AppelFonction(l, List.map (analyse_tds_expression tds) list_expression)
    end
(* Opérateurs *)
  |AstSyntax.Binaire (b,e1,e2) -> let ne1 = analyse_tds_expression tds e1 in 
                                  let ne2 = analyse_tds_expression tds e2 in
                                  AstTds.Binaire(b,ne1,ne2)
  |AstSyntax.Unaire (b,e1) -> let ne1 = analyse_tds_expression tds e1 in 
                                  AstTds.Unaire(b,ne1)
  |AstSyntax.Entier (i) -> AstTds.Entier (i)
  |AstSyntax.Booleen (b) -> AstTds.Booleen(b)
  
  (* Gestion des pointeurs*)
  | AstSyntax.Affectable aff -> Affectable (analyse_tds_affectable tds false aff)
  |AstSyntax.Null -> Null
  |AstSyntax.New t -> New t
  |AstSyntax.Adresse n -> begin
      match chercherGlobalement tds n with
      | None -> raise (IdentifiantNonDeclare n) 
      | Some info ->
        begin
          match info_ast_to_info info with
          |InfoFun _ -> raise (MauvaiseUtilisationIdentifiant n)
          |InfoVar _-> AstTds.Adresse info 
          |InfoConst _ -> raise (MauvaiseUtilisationIdentifiant n)
          |_ -> raise (MauvaiseUtilisationIdentifiant n)
        end 
      end
  (* gestion de la conditionnelle ternaire *)
  |AstSyntax.Conditionnelle_Ternaire(cond,e1,e2) -> let ncond = analyse_tds_expression tds cond in
                                                    let ne1 = analyse_tds_expression tds e1 in
                                                    let ne2 = analyse_tds_expression tds e2 in
                                                    AstTds.Conditionnelle_Ternaire(ncond,ne1,ne2)



(* analyse_tds_instruction : tds -> info_ast option -> AstSyntax.instruction -> AstTds.instruction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si l'instruction i est dans le bloc principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est l'instruction i sinon *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstTds.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_instruction tds oia i =
  match i with

  | AstSyntax.Declaration (t, n, e) ->
      begin
        match chercherLocalement tds n with
        | None ->
            (* L'identifiant n'est pas trouvé dans la tds locale,
            il n'a donc pas été déclaré dans le bloc courant *)
            (* Vérification de la bonne utilisation des identifiants dans l'expression *)
            (* et obtention de l'expression transformée *)
            let ne = analyse_tds_expression tds e in
            (* Création de l'information associée à l'identfiant *)
            let info = InfoVar (n,Undefined, 0, "") in
            (* Création du pointeur sur l'information *)
            let ia = info_to_info_ast info in
            (* Ajout de l'information (pointeur) dans la tds *)
            ajouter tds n ia;
            (* Renvoie de la nouvelle déclaration où le nom a été remplacé par l'information
            et l'expression remplacée par l'expression issue de l'analyse *)
            AstTds.Declaration (t, ia, ne)
        | Some _ ->
            (* L'identifiant est trouvé dans la tds locale,
            il a donc déjà été déclaré dans le bloc courant *)
            raise (DoubleDeclaration n)
      end
  (* Gestion des pointeurs: cd td sur les pointeurs *)
  | AstSyntax.Affectation (n,e) ->
    Affectation (analyse_tds_affectable tds true n, analyse_tds_expression tds e)
    

(* Affectation quand on avait pas de pointeur *)
  (*| AstSyntax.Affectation (n,e) -> 
    begin
      match chercherGlobalement tds n with
      | None ->
        (* L'identifiant n'est pas trouvé dans la tds globale. *)
        raise (IdentifiantNonDeclare n)
      | Some info ->
        (* L'identifiant est trouvé dans la tds globale,
        il a donc déjà été déclaré. L'information associée est récupérée. *)
        begin
          match info_ast_to_info info with
          | InfoVar _ ->
            (* Vérification de la bonne utilisation des identifiants dans l'expression *)
            (* et obtention de l'expression transformée *)
            let ne = analyse_tds_expression tds e in
            (* Renvoie de la nouvelle affectation où le nom a été remplacé par l'information
               et l'expression remplacée par l'expression issue de l'analyse *)
            AstTds.Affectation (info, ne)
          |  _ ->
            (* Modification d'une constante ou d'une fonction *)
            raise (MauvaiseUtilisationIdentifiant n)
        end
    end*)

  | AstSyntax.Constante (n,v) ->
      begin
        match chercherLocalement tds n with
        | None ->
          (* L'identifiant n'est pas trouvé dans la tds locale,
             il n'a donc pas été déclaré dans le bloc courant *)
          (* Ajout dans la tds de la constante *)
          ajouter tds n (info_to_info_ast (InfoConst (n,v)));
          
          (* Suppression du noeud de déclaration des constantes devenu inutile *)
          AstTds.Empty
        | Some _ ->
          (* L'identifiant est trouvé dans la tds locale,
          il a donc déjà été déclaré dans le bloc courant *)
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e ->
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds e in
      (* Renvoie du nouvel affichage où l'expression remplacée par l'expression issue de l'analyse *)
      AstTds.Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc then *)
      let tast = analyse_tds_bloc tds oia t in
      (* Analyse du bloc else *)
      let east = analyse_tds_bloc tds oia e in
      (* Renvoie la nouvelle structure de la conditionnelle *)
      AstTds.Conditionnelle (nc, tast, east)
  |AstSyntax.Conditionnelle_sans_else (c,t) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc then *)
      let tast = analyse_tds_bloc tds oia t in
      (* Renvoie la nouvelle structure de la conditionnelle *)
      AstTds.Conditionnelle_sans_else (nc, tast)
  | AstSyntax.TantQue (c,b) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc *)
      let bast = analyse_tds_bloc tds oia b in
      (* Renvoie la nouvelle structure de la boucle *)
      AstTds.TantQue (nc, bast)
  | AstSyntax.Retour (e) ->
      begin
      (* On récupère l'information associée à la fonction à laquelle le return est associée *)
      match oia with
        (* Il n'y a pas d'information -> l'instruction est dans le bloc principal : erreur *)
      | None -> raise RetourDansMain
        (* Il y a une information -> l'instruction est dans une fonction *)
      | Some ia ->
        (* Analyse de l'expression *)
        let ne = analyse_tds_expression tds e in
        AstTds.Retour (ne,ia)
      end
      (* Analyse d'une boucle à la Rust  ayant une etiquette n *)

      | AstSyntax.Loop_etiquette (n,b) ->
        let tdsf = creerTDSFille tds in
        (* Création d'une infoBoucle : cf tds.ml*)
        let info = InfoBoucle (n) in
        (* on ajoute cette information dans la TDS locale à la Boucle: traitement similaire à une fonction*)
        let i = info_to_info_ast info in
        ajouter tds n i;
        AstTds.Loop_etiquette (i, analyse_tds_bloc tdsf (Some i) b)

      (* Analyse d'une boucle à la Rust  n'ayant pas d'étiquette *)
      |AstSyntax.Loop(b) ->
        let tdsf = creerTDSFille tds in
        let info = InfoBoucle ("") in
        let ia = info_to_info_ast info in
        AstTds.Loop (analyse_tds_bloc tdsf (Some ia) b)

    (* Analyse d'un break à la Rust avec une étiquette *)
    | AstSyntax.Break_etiquette (n) ->
        begin 
          match chercherLocalement tds n with  
          | Some _ -> raise (DoubleDeclaration n)  
          | None ->
            begin
              (* on s'assure que le break ne soit pas dans un main, seul analogie à retour dans main*)
              match oia with 
              | None -> raise BreakLoopDansMain
              | Some ia -> 
                begin 
                  match info_ast_to_info ia with
                  | InfoBoucle (nom) -> 
                    if n = nom then 
                      (* Création d'un InfoBreak et on l'ajoute dans la TDS *)
                      let info = InfoBreak(n) in
                      ajouter tds n (info_to_info_ast info);
                      AstTds.Break_etiquette ((info_to_info_ast info)) 
                      (* si le break n'a pas l'étiquette associée à la Loop*)
                    else raise (IdentifiantNonDeclare n)
                  | _ -> raise (IdentifiantNonDeclare n)
                end
            end
        end

    (* Analyse d'un break à la Rust sans étiquette *)
      |AstSyntax.Break ->
        begin 
          match oia with 
          | None -> raise BreakLoopDansMain
          | Some ia -> 
            begin 
              match info_ast_to_info ia with
              | InfoBoucle (_) -> 
               
                AstTds.Break 
              | _ -> raise BreakLoopDansMain
            end
        end   
      
    (* Analyse d'un continue à la Rust avec une étiquette *)
    | AstSyntax.Continue_etiquette (n) ->
        begin 
          match chercherLocalement tds n with 
          | Some _ -> raise (DoubleDeclaration n)
          | None ->
            begin
              match oia with 
              | None -> raise ContinueLoopDansMain
              | Some ia -> 
                begin 
                  match info_ast_to_info ia with
                  | InfoBoucle (nom) -> 
                    if n = nom then 
                      (* Création de l'information associée au continue *)
                      let info = InfoContinue (n) in
                      (* Création du pointeur sur l'information *)
                      (* Ajout de l'information (pointeur) dans la tds *)
                      ajouter tds n (info_to_info_ast info);
                      AstTds.Continue_etiquette ((info_to_info_ast info)) 
                    else raise (IdentifiantNonDeclare n)
                  | _ -> raise (IdentifiantNonDeclare n)
                end
            end
        end
    (* Analyse d'un continue à la Rust sans étiquette *)
        | AstSyntax.Continue -> 
        begin 
          match oia with 
          | None -> raise ContinueLoopDansMain
          | Some ia -> 
            begin 
              match info_ast_to_info ia with
              | InfoBoucle (_) -> 
               
                AstTds.Continue 
              | _ -> raise ContinueLoopDansMain
            end
        end
        | AstSyntax.SwitchCase (e,l) ->
          let ne = analyse_tds_expression tds e in
          let lc,lli,lb = (List.fold_right(fun(a,b,c) qt -> let (qt1,qt2,qt3) = qt in (a::qt1,b::qt2,c::qt3)) l ([],[],[])) in
          let nlc = List.map (analyse_tds_expression tds) lc in
          let nlb = List.map (analyse_tds_expression tds) lb in
          let nlli = List.map (analyse_tds_bloc tds) lli in
          let nl = begin match nlc,nlli,nlb with
            | [],[],[]-> []
            | [],_,_ | _,[],_ | _,_,[] -> failwith "les listes ne sont pas de même taille"
            | (a::r1,b::r2,c::r3) -> let l = merge3(r1,r2,r3) in (a,b,c)::l
          end
        
        in
          AstTds.SwitchCase (ne,nl)

(* analyse_tds_bloc : tds -> info_ast option -> AstSyntax.bloc -> AstTds.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si le bloc li est dans le programme principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est le bloc li sinon *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_bloc tds oia li =
  (* Entrée dans un nouveau bloc, donc création d'une nouvelle tds locale
  pointant sur la table du bloc parent *)
  let tdsbloc = creerTDSFille tds in
  (* Analyse des instructions du bloc avec la tds du nouveau bloc.
     Cette tds est modifiée par effet de bord *)
   let nli = List.map (analyse_tds_instruction tdsbloc oia) li in
   (* afficher_locale tdsbloc ; *) (* décommenter pour afficher la table locale *)
   nli

   (* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction *)
   (* Paramètre maintds : la table des symboles courante *)
   (* Paramètre : la fonction à analyser *)
   (* Vérifie la bonne utilisation des identifiants et tranforme la fonction
   en une fonction de type AstTds.fonction, on prend en compte la surcharge *)
   (* Erreur si mauvaise utilisation des identifiants *)
let creation_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li)) = 
  (* Création de la tds et des infos de la fonction*)
  let tdsf = creerTDSFille maintds in
  let info = InfoFun (n, t, (List.map fst lp)) in
  (* Ajout de l'info dans la tds *)
  let ia = info_to_info_ast info in
  ajouter maintds n ia;
  (* Paramètre de la fonction *)
  let nlp = List.map (fun (typ, name) ->
     begin
      (* On regarde d'abord si le paramètre n'existe pas déjà*)
       match chercherLocalement tdsf name with
       | Some _ -> raise (DoubleDeclaration name)
       | None ->
         let ia = info_to_info_ast (InfoVar (name, Undefined, 0, "")) in
         ajouter tdsf name ia;
         (typ, ia)
     end) lp in
  AstTds.Fonction(t, ia, nlp, analyse_tds_bloc tdsf (Some ia) li)

(* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre :  fonction à analyser *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li)) = begin
  match chercherLocalement maintds n with
  | Some ria -> 
    begin
      match info_ast_to_info ria with
      | InfoFun(_,_,lt) -> 
        if (not (Type.est_compatible_list (List.map fst lp) lt)) then

          (* Création de la tds et des infos de la fonction*)
            (let tdsf = creerTDSFille maintds in
            let info = InfoFun (n, t, (List.map fst lp)) in
            (* Ajout de l'info dans la tds *)
            let ia = info_to_info_ast info in
            ajouter maintds n ia;
            (* Paramètre de la fonction *)
            let nlp = List.map (fun (typ, name) ->
               begin
                (* On regarde d'abord si le paramètre n'existe pas déjà*)
                 match chercherLocalement tdsf name with
                 | Some _ -> raise (DoubleDeclaration name)
                 | None ->
                   let ia = info_to_info_ast (InfoVar (name, Undefined, 0, "")) in
                   ajouter tdsf name ia;
                   (typ, ia)
               end) lp in
            AstTds.Fonction(t, ia, nlp, analyse_tds_bloc tdsf (Some ia) li))
        else
          raise (DoubleDeclaration n) 
      | _ -> raise (MauvaiseUtilisationIdentifiant n)
    end
        | None ->
          (* Création de la TDS de la fonction et des info de la fonction*)
              let tdsf = creerTDSFille maintds in
              let info = InfoFun (n, t, (List.map fst lp)) in
              (* Ajout de l'info dans la tds *)
              let ia = info_to_info_ast info in
              ajouter maintds n ia;
              (* Paramètre de la fonction *)
              let nlp = List.map (fun (typ, name) ->
                begin
                  (* On regarde d'abord si le paramètre n'existe pas déjà*)
                  match chercherLocalement tdsf name with
                  | Some _ -> raise (DoubleDeclaration name)
                  | None ->
                    let ia = info_to_info_ast (InfoVar (name, Undefined, 0, "")) in
                    ajouter tdsf name ia;
                    (typ, ia)
                end) lp in
              AstTds.Fonction(t, ia, nlp, analyse_tds_bloc tdsf (Some ia) li)
  end
  
     
   


(* analyser : AstSyntax.programme -> AstTds.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstSyntax.Programme (fonctions,prog)) =
  let tds = creerTDSMere () in
  let nf = List.map (analyse_tds_fonction tds) fonctions in
  let nb = analyse_tds_bloc tds None prog in
  AstTds.Programme (nf,nb)


  

 





  

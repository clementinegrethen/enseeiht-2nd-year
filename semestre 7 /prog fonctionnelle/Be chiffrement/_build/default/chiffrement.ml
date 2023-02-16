open Dr

(* Exception levée quand le code ne peut pas être déchiffré avec l'arbre de chiffrement *)
exception CodeNonValide
(* Exception levée quand la donnée ne peut pas être chiffrée avec l'arbre de chiffrement *)
exception DonneeNonValide

module Arbre =
struct

  (* Arbre de chiffrement : arbre n-aire avec données de type 'b dans les branches et 'f dans les feuilles *)
  type ('b,'f) arbre_chiffrement =  Lettre of 'f | Noeud of ('b * ('b,'f) arbre_chiffrement) list

  (* Exemple d'arbre de chiffrement *)



  (* Exemple d'arbre de chiffrement *)

  (* Arbre de chiffrement de la figure 1 du sujet *)
let arbre1 =
    Noeud ([
        (1,Noeud ([(1,Lettre 'e');(2,Lettre 'b')]) );
         (2,Noeud (
                [(1,Noeud ([(2,Lettre 'c');(3,Lettre 'f')]));
                 (2,Lettre 'd')]));
         (3,Lettre 'a')]
      )
 

  (* Arbre de chiffrement de la figure 2 du sujet *)
  let arbre2 =
    Noeud ([(1,Lettre 'a');(2,Lettre 'b'); (3,Lettre 'c')])
 

  (* Arbre de chiffrement de la figure 3 du sujet *)
 let arbre3 =
    Noeud([
          ('a', Noeud([('u',Lettre 'a');('a', Lettre 'b')]));
          ('e', Lettre 'c');
          ('i', Noeud([('o',Lettre 'd');('u',Lettre 'e');('e',Lettre 'f')]))
      ])
 

  (* Arbre de chiffrement de la figure 4 du sujet *)
  let arbre4 =
    Noeud([
          ('a',Lettre 'c');
          ('b', Lettre 'd');
          ('c', Lettre 'e');
          ('d', Lettre 'f');
          ('e', Lettre 'a');
          ('f', Lettre 'b')
      ])
 

  (*  get_branche : 'b ->  ('b,'f) arbre_chiffrement -> ('b,'f) arbre_chiffrement option**)
  (*  Cherche la branche qui est étiquetée par e et renvoie le sous-arbre associé *)
  let get_branche = fun e a ->
    match a with
    |Lettre _ -> None
    |Noeud l -> List.assoc_opt e l;;
  
    let%test _ = get_branche 1 arbre1 = Some (Noeud ([(1,Lettre 'e');(2,Lettre 'b')]))
  let%test _ = get_branche 2 arbre2 = Some (Lettre 'b')
  let%test _ = get_branche 'i' arbre3 = Some (Noeud([('o',Lettre 'd');('u',Lettre 'e');('e',Lettre 'f')]))
  let%test _ = get_branche 'd' arbre4 = Some (Lettre 'f')
 

  (*  dechiffrer : 'b list -> ('b,'f) arbre_chiffrement -> 'f list **)
  (*  transforme un code (sous forme de liste des symboles de l'alphabet des code) à l'aide d'un arbre **)
  (*  renvoie la donnée déchiffrée, sous forme de liste de symboles de l'alphabet des données **)
  (*  Exception CodeNonValide : si le code ne peut pas être déchiffré avec l'arbre de chiffrement**)
  let dechiffrer  = fun code a ->
    let rec aux = fun code a acc ->
      match code with
      |[] -> acc
      |e::l -> match get_branche e a with
               |None -> raise CodeNonValide
               |Some a' -> match a' with
                           |Lettre f -> aux l a (f::acc)
                           |Noeud _ -> aux l a' acc
    in List.rev (aux code a []);;
      

      


(*  let%test _ = dechiffrer [1;2;3;2;1;2] arbre1 = ['b';'a';'c']
  let%test _ = dechiffrer [1;2;3] arbre1 = ['b';'a']
  let%test _ = try let _ = dechiffrer [3;2;1;3;2;1] arbre1 in false with CodeNonValide -> true

  let%test _ = dechiffrer [1;2;3;2;1;2] arbre2 = ['a';'b';'c';'b';'a';'b']
  let%test _ = dechiffrer [1;2;3] arbre2 = ['a';'b';'c']
  let%test _ = dechiffrer [3;2;1;3;2;1] arbre2 = ['c';'b';'a';'c';'b';'a']
  let%test _ = try let _ = dechiffrer [4;5;7] arbre2 in false with CodeNonValide -> true

  let%test _ = dechiffrer ['a';'u'] arbre3 = ['a']
  let%test _ = dechiffrer ['a';'a'] arbre3 = ['b']
  let%test _ = dechiffrer ['e'] arbre3 = ['c']
  let%test _ = dechiffrer ['a';'a';'a';'u';'e'] arbre3 = ['b';'a';'c']

  let%test _ = dechiffrer ['f';'e';'a'] arbre4 = ['b';'a';'c']
 *)

  (*  arbre_to_list : ('b,'f) arbre_chiffrement -> ('f * 'b list ) list **)
  (*  Converti un arbre de chiffrement  en une liste associative (symbole de l'alphabet des données, code - liste de symboles de l'alphabet des codes)**)
  let  arbre_to_liste  =   fun arbre -> 
    let rec aux = fun arbre acc code ->
      match arbre with
      |Lettre f -> (f,code)::acc
      |Noeud l -> List.fold_left (fun acc (e,a) -> aux a acc (e::code)) acc l
    in aux arbre [] [];;
    

   let%test _ = arbre_to_liste arbre1 = [('a',[3;2;1]);('b',[1;2]);('c',[1;2;3]);('d',[2;2])]

  (*  [eq_perm l l'] retourne true ssi [l] et [l']
      sont égales à à permutation près (pour (=)).
      [l'] ne doit pas contenir de doublon. *)
  let eq_prem l l' =
    List.length l = List.length l' && List.for_all (fun x -> List.mem x l) l'

(*  let%test _ = eq_prem (arbre_to_liste arbre2) ['a',[1]; 'b',[2]; 'c',[3]]

  let%test _ =
    eq_prem
      (arbre_to_liste arbre3)
      ['a',['a';'u']; 'b',['a';'a']; 'c',['e']; 'd',['i';'o']; 'e',['i';'u'];
       'f',['i';'e']]

  let%test _ =
    eq_prem
      (arbre_to_liste arbre4)
      ['a',['e']; 'b',['f']; 'c',['a']; 'd',['b']; 'e',['c']; 'f',['d']]
 *)

  (*  chiffrer : 'f list -> ('b,'f) arbre_chiffrement -> 'b list **)
  (*  transforme une donnée (sous forme de liste de symboles de l'alphabet des données)  **)
  (*  renvoie le code associé à la donnée, pour l'abre, sous forme de liste de symboles de l'alphabet des codes **)
  (*  Exception DonneeNonValide : si la donnéee ne peut pas être chiffrée avec l'arbre de chiffrement **)
  let chiffrer   = fun liste_symbole arbre ->
    let liste_arbre= arbre_to_liste arbre in 
    let rec aux = fun liste_symbole abre acc ->
      match liste_symbole with
      |[] -> acc
      |e::l -> match List.assoc e liste_arbre with
               |[] -> raise DonneeNonValide
               |a' -> aux l abre (acc@a')
    in (aux liste_symbole arbre []);;
                        
    

(*  let%test _ = chiffrer ['b';'a';'c'] arbre1 = [1;2;3;2;1;2]
  let%test _ = chiffrer ['b';'a'] arbre1 = [1;2;3]

  let%test _ = chiffrer ['a';'b';'c';'b';'a';'b'] arbre2 = [1;2;3;2;1;2]
  let%test _ = chiffrer ['a';'b';'c'] arbre2 = [1;2;3]
  let%test _ = chiffrer ['c';'b';'a';'c';'b';'a'] arbre2 = [3;2;1;3;2;1]
  let%test _ = try let _ = chiffrer ['d';'a';'b'] arbre2 in false with DonneeNonValide -> true 
  let%test _ = try let _ = chiffrer ['z';'u';'t'] arbre2 in false with DonneeNonValide -> true

  let%test _ = chiffrer ['b';'a';'c'] arbre3 = ['a';'a';'a';'u';'e']

  let%test _ = chiffrer ['b';'a';'c'] arbre4 = ['f';'e';'a']
 *)

  (*****************************************)
  (*  BONUS                               **)
  (*****************************************)

  (*  fold :  
      ('b -> 'f -> 'b) -> 'b -> ('b,'f) arbre_chiffrement -> 'b **)
  (*  applique la fonction [f] à chaque symbole de l'alphabet des données **)

   **)
  let rec fold =    fun f g arbre ->
    match arbre with
    |Lettre f -> f
    |Noeud l -> g (List.map (fun (e,a) -> (e,fold f g a)) l);;

  (*  map :  TO DO
   **)

  (*  nb_symboles : ('b,'f) arbre_chiffrement : ('b,'f) arbre_chiffrement -> int
      Fonction qui calcule le nombre de symboles de l'alphabet des données présentent dans un arbre de chiffrement
      Paramètre : l'arbre de chiffrement
      Retour : le nombre de synboles de l'alphabet des données
   **)
  let nb_symboles = 

(*  let%test _ = nb_symboles arbre1 = 6
  let%test _ = nb_symboles arbre2 = 3
  let%test _ = nb_symboles arbre3 = 6
  let%test _ = nb_symboles arbre4 = 6
 *)

  (*  symboles :  ('b,'f) arbre_chiffrement -> 'f list
      Fonction qui renvoie la liste des symboles de l'alphabet des données présents dans un arbre de chiffrement
      Paramètre : l'arbre de cryage
      Retour : la liste des symboles
   **)
  let symboles = fun _ -> assert false

(*  let%test _ = eq_prem (symboles arbre1) ['a'; 'b'; 'c'; 'd'; 'e'; 'f']
  let%test _ = eq_prem (symboles arbre2) ['a'; 'b'; 'c']
  let%test _ = eq_prem (symboles arbre3) ['a'; 'b'; 'c'; 'd'; 'e'; 'f']
  let%test _ = eq_prem (symboles arbre4) ['a'; 'b'; 'c'; 'd'; 'e'; 'f']
 *)

  (*  arbre_to_liste_2 :  ('b,'f) arbre_chiffrement -> ('f * 'b list ) list **)
  (*  Converti un arbre de chiffrement en une liste associative (symbole de l'alphabet des données, code - liste de symboles de l'alphabet des codes)**)
  let arbre_to_liste_2  = fun _ -> assert false

(*  let%test _ =
    eq_prem
      (arbre_to_liste_2 arbre1)
      ['a',[3]; 'b',[1;2]; 'c',[2;1;2]; 'd',[2;2]; 'e',[1;1]; 'f',[2;1;3]]

  let%test _ = eq_prem (arbre_to_liste_2 arbre2) ['a',[1]; 'b',[2]; 'c',[3]]

  let%test _ =
    eq_prem
      (arbre_to_liste_2 arbre3)
      ['a',['a';'u']; 'b',['a';'a']; 'c',['e']; 'd',['i';'o']; 'e',['i';'u'];
       'f',['i';'e']]

  let%test _ =
    eq_prem
      (arbre_to_liste_2 arbre4)
      ['a',['e']; 'b',['f']; 'c',['a']; 'd',['b']; 'e',['c']; 'f',['d']]
 *)
end

module Chiffrement (DRDonnee : DecomposeRecompose) (DRCode : DecomposeRecompose)=
struct

  type donnee = DRDonnee.mot
  type symbole_donnee = DRDonnee.symbole
  type symbole_code = DRCode.symbole
  type code = DRCode.mot

  (* dechiffrer : code -> (symbole_code,symbole_donnee) arbre_chiffrement -> donnee
     Déchiffre un code en utilisant l'abre de chiffrement
     Paramètre code : le code à déchiffrer
     Paramètre arbre : l'arbre de chiffrement
     Retour : la donnée déchiffrée
     Exception CodeNonValide : si le code ne peut pas être déchiffré avec l'arbre de chiffrement
   *)
  let dechiffrer = fun code arbre -> 
    let l = Arbre.dechiffrer (DRDonnee.decompose code) arbre in 
    DRCode.recompose(l);;


  (* chiffrer : donnee -> (symbole_code,symbole_donnee) arbre_chiffrement -> code
     chiffre une donnée à l'aide d'un arbre de chiffrement
     Paramètre donnee : la donnée à chiffrer
     Paramètre arbre : l'arbre de chiffrement
     Retour : le code associé à la donnée
     Exception DonneeNonValide : si la donnéee ne peut pas être chiffrée avec l'arbre de chiffrement 
   *)
  let chiffrer = fun donnee arbre -> 
    let l = Arbre.chiffrer (DRDonnee.decompose donnee) arbre in 
    DRCode.recompose(l);;

end

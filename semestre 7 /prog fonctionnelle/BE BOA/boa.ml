
module type Regle =
sig
  type tid = int
  type td
  val id : tid
  val appliquer : td -> td list
end

module Regle1: Regle with type td= char list = struct 
  type tid= int
  type td= char list
  let id =1
  let appliquer terme = 
    match List.rev terme with
    |[]->[[]]
    |t::q when t ='O' -> [terme@['A']]
    |t::q -> [terme];;
  end 


  (* Definition de mot pour tester sles regles *)
let exemple1 = ['B';'O']
let exemple2 = ['B';'O';'A']
let exemple3 = ['B';'O';'O';'O';'O']
let exemple4 = ['B';'O';'A';'A';'O']

(*test règle 1*)
let%test _ = Regle1.appliquer exemple1 = [['B';'O';'A']]
let%test _ = Regle1.appliquer exemple2 = [['B';'O';'A']]
let%test _ = Regle1.appliquer exemple3 = [['B';'O';'O';'O';'O';'A']]
let%test _ = Regle1.appliquer exemple4 = [['B';'O';'A';'A';'O';'A']]

module Regle2: Regle with type td= char list = struct 
  type tid= int
  type td= char list
  let id =2
  let appliquer terme = 
    match  terme with
    |[]->[[]]
    |t::q when t ='B' -> [terme@q]
    |t::q -> [terme];;
  end 

  let%test _ = Regle2.appliquer exemple1 = [['B';'O';'O']]
let%test _ = Regle2.appliquer exemple2 = [['B';'O';'A';'O';'A']]
let%test _ = Regle2.appliquer exemple3 = [['B';'O';'O';'O';'O';'O';'O';'O';'O']]
let%test _ = Regle2.appliquer exemple4 = [['B';'O';'A';'A';'O';'O';'A';'A';'O']]


module Regle3: Regle with type td= char list = struct 
  type tid= int
  type td= char list
  let id =2
  let appliquer terme = 
    let chaineO = ['O';'O';'O'] and chaineA = ['A';'O';'A'] in
    match  terme with
    |[]->[[]]
    ||a::b::c::q -> if [a;b;c] = chaineO || [a;b;c] = chaineA then (('A')::q)::(List.map (fun l -> a::l) (appliquer (b::c::q)))
    else (List.map (fun l -> a::l) (appliquer (b::c::q)))
| t::q -> (List.map (fun l -> t::l) (appliquer q))
end 
  (*test règle 3*)
let%test _ = Regle3.appliquer exemple1 = [['B';'O']]
let%test _ = Regle3.appliquer exemple2 = [['B';'O';'A']]
let%test _ = Regle3.appliquer exemple3 = [['B';'A';'O']; ['B';'O';'A']]
let%test _ = Regle3.appliquer exemple4 = [['B';'O';'A';'A';'O']]

module Regle4 : Regle with type td = char list =
struct
  type tid = int
  type td = char list
  let id = 4
  let rec appliquer terme =
    let chaine = ['A';'A'] in
    match terme with
    |[] -> []
    |a::b::q -> if [a;b] = chaine then q::(List.map (fun l -> a::l) (appliquer (b::q)))
                    else (List.map (fun l -> a::l) (appliquer (b::q)))
    | t::q -> (List.map (fun l -> t::l) (appliquer q))
end


module type ArbreReecriture =
sig
  
  type tid = int
  type td
  type arbre_reecriture = Noeud of td * (branche list) and branche = tid * arbre_reecriture

  val creer_noeud : arbre_reecriture -> td -> arbre_reecriture

  val racine : arbre_reecriture -> td 
  val fils : arbre_reecriture -> tid -> arbre_reecriture list

  val appartient : td -> arbre_reecriture -> bool
  
end

module tye ArbreReecritureBOA: ArbreReecriture with type td = char list =
struct
  type id = int
  type td = char list
  type arbre_reecriture = Noeud of td * (branche list) and branche = tid * arbre_reecriture
  let creer_neoud terme arbre =


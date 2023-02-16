
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

module type ArbreReecriture =
sig
  (*
  type tid = int
  type td
  type arbre_reecriture = ...

  val creer_noeud : ...

  val racine : ...
  val fils : ..

  val appartient : td -> arbre_reecriture -> bool
  *)
end


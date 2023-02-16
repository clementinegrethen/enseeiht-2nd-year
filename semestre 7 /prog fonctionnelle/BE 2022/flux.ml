(* Implantation des flux par des listes paresseuses infinies *)
type 'a flux_t = Tick of ('a * 'a flux_t) Lazy.t;;

(* Interface des flux *)
module type Iter =
sig
  type 'a t = 'a flux_t
  val cons : 'a -> 'a t -> 'a t
  val uncons : 'a t -> 'a * 'a t
  val unfold : ('s -> 'a * 's) -> 's -> 'a t
  val filter : ('a -> bool) -> 'a t -> 'a t                     
  val constant : 'a -> 'a t
  val map : ('a -> 'b) -> 'a t -> 'b t
  val apply : ('a -> 'b) t -> 'a t -> 'b t
  val map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
  val print : (Format.formatter -> 'a -> unit) -> int -> Format.formatter -> 'a t -> unit
end

(* module réalisant l'interface *)
module Flux : Iter =
  struct
    type 'a t = 'a flux_t;;

    let cons t q = Tick (lazy (t, q));;

    let uncons (Tick flux) = Lazy.force flux;;

    let rec apply f x =
      Tick (lazy (
      match uncons f, uncons x with
      | (tf, qf), (tx, qx) -> (tf tx, apply qf qx)));;

    let rec unfold f e =
      Tick (lazy (
      match f e with
      | (t, e') -> (t, unfold f e')));;

    let rec filter p flux =
      Tick (lazy (
      match uncons flux with
      | (t, q) -> if p t then (t, filter p q)
                  else uncons (filter p q)));;
    
    let constant c = unfold (fun () -> (c, ())) ();;

    let rec map f flux =
      Tick (lazy (
      match uncons flux with
      | (t, q) -> (f t, map f q)));;

    let rec map2 f flux1 flux2 =
      Tick (lazy (
      match uncons flux1, uncons flux2 with
      | (t1, q1), (t2, q2) -> (f t1 t2, map2 f q1 q2)));;

    let rec print pe n fmt flux =
      if n <= 0 then Format.fprintf fmt "@ " else
        let (f0, f') = uncons flux in 
        Format.fprintf fmt "%a %a" pe f0 (print pe (n-1)) f';;

end

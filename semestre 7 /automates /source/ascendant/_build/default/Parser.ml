
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | UL_VIRG
    | UL_VARIABLE of (
# 17 "Parser.mly"
       (string)
# 16 "Parser.ml"
  )
    | UL_SYMBOLE of (
# 16 "Parser.mly"
       (string)
# 21 "Parser.ml"
  )
    | UL_PT
    | UL_PAROUV
    | UL_PARFER
    | UL_FIN
  
end

include MenhirBasics

# 1 "Parser.mly"
  

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)


# 40 "Parser.ml"

type ('s, 'r) _menhir_state

and 's _menhir_cell0_regle = 
  | MenhirCell0_regle of 's * (unit)

and _menhir_box_programme = 
  | MenhirBox_programme of (unit) [@@unboxed]

let _menhir_action_1 =
  fun () ->
    (
# 31 "Parser.mly"
                                     ( (print_endline "programme : regle suite_regle FIN ") )
# 55 "Parser.ml"
     : (unit))

let _menhir_action_2 =
  fun () ->
    (
# 33 "Parser.mly"
        ( (print_endline "regle : A COMPLETER") )
# 63 "Parser.ml"
     : (unit))

let _menhir_action_3 =
  fun () ->
    (
# 35 "Parser.mly"
              ( (print_endline "suite_regle : A COMPLETER") )
# 71 "Parser.ml"
     : (unit))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | UL_FIN ->
        "UL_FIN"
    | UL_PARFER ->
        "UL_PARFER"
    | UL_PAROUV ->
        "UL_PAROUV"
    | UL_PT ->
        "UL_PT"
    | UL_SYMBOLE _ ->
        "UL_SYMBOLE"
    | UL_VARIABLE _ ->
        "UL_VARIABLE"
    | UL_VIRG ->
        "UL_VIRG"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37-39"]
  
  let rec _menhir_run_0 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_programme =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_2 () in
      let _menhir_stack = MenhirCell0_regle (_menhir_stack, _v) in
      let _ = _menhir_action_3 () in
      match (_tok : MenhirBasics.token) with
      | UL_FIN ->
          let MenhirCell0_regle (_menhir_stack, _) = _menhir_stack in
          let _v = _menhir_action_1 () in
          MenhirBox_programme _v
      | _ ->
          _eRR ()
  
end

let programme =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_programme v = _menhir_run_0 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v

# 37 "Parser.mly"
  

# 126 "Parser.ml"


let trace_fonctions (xmin, xmax) (liste_f : ((float -> float) * Graphics.color) list) =
 let width = 800 in
 let height = 600 in
 let liste_tab = List.map (fun (f, _) -> Array.init (width+1) (fun i -> f (xmin +. (xmax -. xmin) *. (float_of_int i) /. (float_of_int width)))) liste_f
 in
 let liste_coul = List.map snd liste_f in
 let liste_real_ymin = List.map (fun tab -> Array.fold_left min (tab.(0)) tab) liste_tab in
 let liste_real_ymax = List.map (fun tab -> Array.fold_left max (tab.(0)) tab) liste_tab in
 let real_ymin = List.fold_left min (List.hd liste_real_ymin) (List.tl liste_real_ymin) in
 let real_ymax = List.fold_left max (List.hd liste_real_ymax) (List.tl liste_real_ymax) in
 let real_delta = real_ymax -. real_ymin in
 let mean  = (real_ymax +. real_ymin) /. 2.0 in
 let ymin = mean -. 1.05 *. real_delta /. 2.0 in
 let ymax = mean +. 1.05 *. real_delta /. 2.0 in
 let delta = ymax -. ymin in
 let convert y = int_of_float (float_of_int height *. (y -. ymin) /. delta) in
 Graphics.open_graph (Printf.sprintf " %dx%d" width height);
 Graphics.set_color Graphics.black;
 if (ymin < 0.0 && ymax > 0.0) then
   (Graphics.moveto 0     (convert 0.0);
    Graphics.lineto width (convert 0.0);
   );
 if (xmin < 0.0 && xmax > 0.0) then
   (let zero = int_of_float (float_of_int width *. xmin /. (xmin -. xmax)) in
    Graphics.moveto zero 0;
    Graphics.lineto zero height;
   );
 List.iter2 (fun tab coul ->
     Graphics.set_color coul;
     Graphics.moveto 0 (convert (tab.(0)));
     Array.iteri (fun i y -> Graphics.lineto i (convert y)) tab)
   liste_tab liste_coul;
 Graphics.set_color Graphics.red;
 let smin = string_of_float xmin in
 Graphics.moveto 1     (height / 2);
 Graphics.draw_string smin;
 Graphics.moveto (width - 1 - fst (Graphics.text_size smin)) (height / 2);
 Graphics.draw_string (string_of_float xmax);
 Graphics.moveto (width / 2) 1;
 Graphics.draw_string (string_of_float real_ymin);
 let smax = string_of_float real_ymax in
 Graphics.moveto (width / 2) (height - 1 - snd (Graphics.text_size smax));
 Graphics.draw_string smax;
 ignore (Graphics.wait_next_event [Graphics.Button_down]);
 Graphics.close_graph ()
;;

let sample ty i = ty.(int_of_float i);;

let trace_fonction (xmin, xmax) f =
  trace_fonctions (xmin, xmax) [ f, Graphics.black ];;

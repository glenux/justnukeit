(* vim: set ts=2 sw=2 et : *)

(** Mouse management and event handling. *)

(** Returns a list of "abstract events" generated 
    by this SDL event *)
let handle_event mouse_ev anon_ev =
  ignore mouse_ev ;
  ignore anon_ev ;
  [Action.None]
;;

let init () =
  (* do nothing *)
  ()
;;

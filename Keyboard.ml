(* vim: set st=2 sw=2 et : *)

module KeyMap = Map.Make(
  struct
    type t = Sdlkey.t

    let compare x y =
      let xval = Sdlkey.int_of_key x
      and yval = Sdlkey.int_of_key y
      in 
      if xval = yval then 0
      else 
        if xval < yval then -1
        else 1

  end
)

type mapdata_editable_t =
  | Static
  | Editable
;;


type key_action_t = mapdata_editable_t * Action.t
;;


type t = {
  mutable map : key_action_t KeyMap.t ;
}
;;


(** used keys *)
let keys = {
  map = KeyMap.empty ;
}

let handle_event key_ev anon_ev =
  let {Sdlevent.keysym = keysym} = key_ev
  in 

  let map_fold_fun map_key map_action action_list = 
    if keysym = map_key then
      let (sub_editable, sub_action) = map_action
      in
      match action_list with
      | [Action.None] -> [sub_action]
      | hd::tail -> 
          raise ( Common.NotImplemented "Keyboard: folding 2 concrete actions" )
      | [] -> [sub_action]
    else
      action_list
  in

  KeyMap.fold map_fold_fun keys.map [Action.None]
;;

let init () =
  (* do nothing *)
  (* init an associative array of 
     key -> actions events 
     with KEY_ESCAPE -> (Action.Quit, 
  *) 
  keys.map <- KeyMap.add Sdlkey.KEY_ESCAPE ( Static, Action.Quit ) keys.map ;
  keys.map <- KeyMap.add Sdlkey.KEY_q ( Static, Action.Quit ) keys.map ;
  ()
;;

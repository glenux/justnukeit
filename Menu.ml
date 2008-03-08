(* vim: set ts=2 sw=2 et : *)

(* position are not absolutes, but percentage *)

type text_t = {
  position: Position.t;
  font: string;
  font_size: int;
};;

type image_t = {
  position: Position.t;
};;

type hover_t = {
  action: unit -> unit ;
};;

type widget_t = 
  | Menu_text of text_t
  | Menu_image of string * Position.t * Position.t
  | Menu_clickable of Position.t * Position.t
  | Menu_hover of string
;;

(* Menu.t *)
type t = {
  widgets : widget_t list ; 
  click_handle : Position.t -> unit ;
  keyboard_handle : string (* Keyboard.a *)
};;

(*
let handle_event ev =
  let actions = (Keyboard.handle_event ev) :: (Mouse.handle_event ev)
  in
  actions;;
*)


type widget_t = 
    | Menu_text of string
    | Menu_image of 
    | Menu_clickable 
;;

type menu_t = {
    widgets : widget_t list ; 
    click_handle : Position.position_t -> unit ;
    keyboard_handle : string (* Keyboard.a *)

;;

let handle_click pos =


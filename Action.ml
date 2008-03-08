(* vim: set ts=2 sw=2 et : *)

type t = 
  | None
  | Quit
;;

type event_t = {
  label : string;
};;


let execute action = 
  ignore action
;;

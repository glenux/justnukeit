(* vim: set ts=2 sw=2 et : *)
open Event;;

type notification_t =
  | Graphics_status of Graphics.status
  | Tick
;;

type game_event_t = 
  | MoveLeft
  | MoveRight
  | MoveUp
  | MoveDown
  | Action
  | ActionTwo
  | Help
  | Quit
  | NoEvent
;;


let game_loop () =
  ()
;;

let main () =
  let player1 = Player.create ()
  and map1 = Maze.create ()
  in
  ignore player1 ;
  ignore map1 ;
  (* open window *)
  (* set parameters & title *)
  game_loop ();
  (* close window *)
;;

main ();

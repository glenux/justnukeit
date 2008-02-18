(* vim: set ts=2 sw=2 et : *)

type game_event_t = 
  | MoveLeft
  | MoveRight
  | MoveUp
  | MoveDown
  | Action
  | ActionTwo
  | Help
  | Quit
  | None
;;

let dispatch_event status =
  if status.Graphics.keypressed then
    match status.Graphics.key with
    | 'q' -> Quit
    | _ -> None
  else
    None
;;

let game_loop () =
  let continue = ref true
  in
  while !continue do
    match dispatch_event ( Graphics.wait_next_event [Graphics.Poll] ) with
    | Quit -> 
        continue := false ;
        print_string "Exiting...\n";
    | _ -> print_string "nothing...\n";
  done
;;

let main () =
  let player1 = Player.create ()
  and map1 = Maze.create ()
  in
  Graphics.open_graph " 320x200+50+50";
  Graphics.set_window_title "Just Nuke It";
  game_loop ();
  Graphics.close_graph ()
;;

main ();

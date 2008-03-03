(* vim: set st=2 sw=2 et : *)

type game_t = {
  level: Level.level_t ;
  players: Player.player_t array ;
  (* monsters: Monster.monster.t array ; *)
  timeline : Timeline.timeline_t ;
}

let handle_event ev =
  ignore ev ; []
;;

let rec refresh_input () = 
  (* poll events *)
  let match_quit ev =
    if ev = Sdlevent.QUIT then true
    else false
  in

  let match_handler ev = 
    match ev with
    (* key events *)
    | Sdlevent.KEYDOWN _ -> Keyboard.handle_event
    | Sdlevent.KEYUP _ -> Keyboard.handle_event
    (* mouse events *)
    | Sdlevent.MOUSEMOTION _ -> Mouse.handle_event
    | Sdlevent.MOUSEBUTTONDOWN _ -> Mouse.handle_event
    | Sdlevent.MOUSEBUTTONUP _ -> Mouse.handle_event
    (* joystick events *)
    | Sdlevent.JOYAXISMOTION _ -> Joystick.handle_event
    | Sdlevent.JOYBALLMOTION _ -> Joystick.handle_event
    | Sdlevent.JOYHATMOTION _ -> Joystick.handle_event
    | Sdlevent.JOYBUTTONDOWN _ -> Joystick.handle_event
    | Sdlevent.JOYBUTTONUP _ -> Joystick.handle_event
    (* video events *)
    | Sdlevent.VIDEORESIZE _ -> Video.handle_event
    | Sdlevent.VIDEOEXPOSE -> Video.handle_event
    | Sdlevent.ACTIVE _ -> Video.handle_event
    (* system events *)
    | Sdlevent.QUIT -> handle_event
    | Sdlevent.SYSWM -> handle_event
    (* user defined events *)
    | Sdlevent.USER _ -> (fun x -> ignore x ; [] )
  in

  let some_event = Sdlevent.poll ()
  in

  match some_event with
  | Some ev -> 
      let handler = match_handler ev
      and quit = match_quit ev
      in  
      ignore ( handler ev );
      if not quit then refresh_input ()
     
  | None -> ()
;;

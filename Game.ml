(* vim: set st=2 sw=2 et : *)

type game_t = {
  mutable level: Level.t ;
  mutable players: Player.t option array ;
  (* monsters: Monster.monster.t array ; *)
  mutable timeline : Timeline.t ;
  mutable config : Config.t ;
  mutable actions : Action.t list ;
  mutable quit : bool ;
}


let create () = 
  let level_data = Level.create ()
  and players_data = Array.make 2 (Some( Player.create() ))
  and timeline_data = Timeline.create ()
  and config_data = Config.create ()
  in 
  {
    level = level_data ; 
    players = players_data ;
    timeline = timeline_data ;
    config = config_data ;
    actions = [] ;
    quit = false ;
  }
;;

let configure game = 
  Config.parse_cmdline game.config;
  Config.parse_file game.config
;;

let init game =
  Video.init game.config;
  Mouse.init () ;
  Keyboard.init () ;
  () 
;;

(* FIXME: create some event mapper using configuration 
 * lile « var event_config_map : game_config -> sdl_event -> event_action »
 * and use it to match event_actions (for game actions) instead of matching SDL
 * events
 *)
let add_actions game = 
  let anon_handler anon_ev = 
    match anon_ev with
    (* key events *)
    | Sdlevent.KEYDOWN key_ev -> Keyboard.handle_event key_ev
    | Sdlevent.KEYUP key_ev -> Keyboard.handle_event key_ev
    (* mouse events *)
    | Sdlevent.MOUSEMOTION mouse_ev -> Mouse.handle_event mouse_ev
    | Sdlevent.MOUSEBUTTONDOWN mouse_ev -> Mouse.handle_event mouse_ev
    | Sdlevent.MOUSEBUTTONUP mouse_ev -> Mouse.handle_event mouse_ev
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
    | Sdlevent.QUIT -> (fun x -> ignore x ; [Action.Quit] )
    | Sdlevent.SYSWM -> (fun x -> ignore x ; [Action.None] )
    (* user defined events *)
    | Sdlevent.USER user_ev -> (fun x -> ignore x ; ignore user_ev ; [Action.None] )
  in

  let some_event = Sdlevent.poll ()
  in

  match some_event with
  | Some anon_ev -> 
      let specific_handler = anon_handler anon_ev 
      in

      (* return actions resulting from selected handler *)
      game.actions <- ( game.actions @ ( specific_handler anon_ev ) ) ;
      ()

  | None -> 
      ()
;;


(** Looping while the program is active *)
let rec loop game = 
  Sdltimer.delay 100 ;
  (* poll events  and get actions *)
  add_actions game ;
  (* remove and run "head" action from action list *)
  (* and quit = match_quit anon_ev *)
  (* if not quit then loop game *)
  let remaining_actions () = ( game.actions != [] )
  in

  while (remaining_actions ()) do
    let hd::tail = game.actions 
    in

    game.actions <- tail ;
    if hd = Action.Quit then
      begin
        print_string "Leaving game...\n" ;
        game.quit <- true
      end
    else
      begin
        print_string "Executing action...\n" ;
        Action.execute hd
      end
  done ;
  if not game.quit then loop game
;;
